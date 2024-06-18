page 50116 "Point Of Sales"
{
    Caption = 'Point of Sale';
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = const(Invoice));
    Editable = true;
    InsertAllowed = false;
    PageType = Document;
    UsageCategory = Tasks;
    ApplicationArea = All;
    AboutTitle = 'Welcome to Point of Sale';
    AboutText = 'You can start scanning item from this screen to quickly sell a lot of stuff in your nice shop.';

    layout
    {
        area(Content)
        {
            field(Status; PosStatus)
            {
                Caption = 'Status';
                ApplicationArea = all;
                Editable = false;
                AboutTitle = 'Receipt Status';
                AboutText = 'Here you can see if you have an active receipt.';
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = all;
            }
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = all;
                AboutTitle = 'Specify the customer';
                AboutText = 'If your''re not selling with cash payment, then you can specify a customer here';
            }
            part(Lines; "POS Lines")
            {
                SubPageLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                ApplicationArea = all;
                AboutTitle = 'Receipt Lines';
                AboutText = 'Here are all the items on the receipt that has been entered or scanned.';
            }
            usercontrol(Scanner; ScannerInterface)
            {
                ApplicationArea = all;
                trigger Scanned(Barcode: Text)
                var
                    Item: Record Item;
                    PM: Record "Payment Method";
                begin
                    case PosStatus of
                        PosStatus::"Awaiting new Receipt":
                            begin
                                NewReceipt();
                                if Item.get(Barcode) then
                                    ScanItem(Item);
                            end;
                        PosStatus::"Receipt Active":
                            begin
                                if Item.Get(BarCode) then
                                    ScanItem(Item)
                                else
                                    if PM.Get(BarCode) then
                                        PayAndPost(PM);
                            end;
                    end;
                end;
            }
        }
        area(FactBoxes)
        {
            part(Total; "Receipt Total")
            {
                SubPageLink = "Document Type" = field("Document Type"), "No." = field("No.");
                ApplicationArea = all;
                AboutTitle = 'Receipt Totals';
                AboutText = 'Here you can check the total of the receipt during entry and scanning.';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(NewReceiptAction)
            {
                Caption = 'New Receipt';
                ApplicationArea = All;
                Image = NewReceipt;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                AboutTitle = 'Start a new receipt';
                AboutText = 'Click here to start a new receipt, or you can just start scanning if you have a scanner.';
                trigger OnAction()
                begin
                    NewReceipt();
                end;
            }
            action(PayAction)
            {
                Caption = 'Pay';
                ApplicationArea = All;
                Image = Payment;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                AboutTitle = 'Receive Payment';
                AboutText = 'Click "Pay" to receive payment from the customer';
                trigger OnAction()
                var
                    PM: REcord "Payment Method";
                    Post: Codeunit "Sales-Post";
                begin
                    PM.Setrange("POS Payment", true);
                    if page.Runmodal(Page::"Select Payment Method", PM) = Action::LookupOK then begin
                        PayAndPost(PM);
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.setfilter("No.", '%1', '');
        PosStatus := PosStatus::"Awaiting new Receipt";
    end;

    procedure NewReceipt()
    var
        Setup: Record "POS Setup";
        SH: Record "Sales Header";
    begin
        Setup.GET();
        SH.Init();
        SH."Document Type" := SH."Document Type"::Invoice;
        SH.Insert(true);
        Rec.Setfilter("No.", SH."No.");
        Rec.FindFirst();
        Rec.Validate(Rec."Sell-to Customer No.", Setup."Cash Customer");
        Rec.Validate(Rec."Posting Date", TODAY());
        Rec.Modify(true);
        PosStatus := PosStatus::"Receipt Active";
    end;

    local procedure ScanItem(Item: Record Item)
    var
        SL: Record "Sales Line";
        NextNo: Integer;
        Release: Codeunit "Release Sales Document";
    begin
        Release.Reopen(Rec);
        SL.setrange("Document Type", Rec."Document Type");
        SL.Setrange("Document No.", Rec."No.");
        SL.Setrange(Type, SL.Type::Item);
        SL.Setrange("No.", Item."No.");
        if Sl.FindFirst() then begin
            SL.Validate(Quantity, SL.Quantity + 1);
            SL.Modify(true);
        end else begin
            SL.Setrange("No.");
            SL.Setrange(Type);
            if SL.FindLast() then
                NextNo := SL."Line No." + 10000
            else
                NextNo := 10000;
            SL.Reset();
            SL.Init();
            SL."Document type" := Rec."Document Type";
            SL."Document No." := Rec."No.";
            Sl."Line No." := NextNo;
            SL.Insert(true);
            SL.Validate(Type, SL.Type::Item);
            SL.Validate("No.", Item."No.");
            SL.Validate(Quantity, 1);
            Sl.Modify(true);
        end;
        Release.Run(Rec);
    end;

    local procedure PayAndPost(PM: Record "Payment Method")
    var
        Post: Codeunit "Sales-Post";
    begin
        Rec.Validate("Payment Method Code", PM.Code);
        Rec.Modify(true);
        Post.SetSuppressCommit(true);
        Post.Run(Rec);
        page.run(PAGE::"Point Of Sales");
    end;

    var
        PosStatus: Option "Awaiting new Receipt","Receipt Active";


    procedure updateItemtracking(RecSalesLine: Record "Sales Line")
    Var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        CreatereservationEntry: Codeunit "Create Reserv. Entry";
        i: integer;
        RemQty: Decimal;
        AssignQty: Decimal;
        TempReservationEntry: Record "Reservation Entry" temporary;
        EntryNo: Integer;
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document No.", RecSalesLine."Document No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindSet() then
            repeat
                SalesLine.Testfield("No.");
                SalesLine.Testfield(Quantity);
                SalesLine.Testfield("Location Code");
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.Ascending(true);
                ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
                ItemLedgerEntry.SetRange("Location Code", SalesLine."Location Code");
                ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
                if ItemLedgerEntry.FindSet() then
                    i := 0;
                RemQty := SalesLine.Quantity; //200
                AssignQty := 0;
                EntryNo := 0;
                repeat
                    if RemQty < ItemLedgerEntry."Remaining Quantity" then
                        AssignQty := RemQty
                    else
                        AssignQty := ItemLedgerEntry."Remaining Quantity";
                    RemQty := RemQty - ItemLedgerEntry."Remaining Quantity";
                    i += AssignQty;

                    TempReservationEntry.Init();
                    if TempReservationEntry.FindLast() then
                        EntryNo := TempReservationEntry."Entry No." + 1
                    else
                        EntryNo := 1;
                    TempReservationEntry."Entry No." := EntryNo;
                    TempReservationEntry."Lot No." := ItemLedgerEntry."Lot No.";
                    TempReservationEntry.Quantity := AssignQty;
                    TempReservationEntry.Insert();

                    CreatereservationEntry.SetDates(0D, ItemLedgerEntry."Expiration Date");
                    CreatereservationEntry.CreateReservEntryFor(
                    Database::"Sales Line", 1,
                    SalesLine."Document No.", '', 0, SalesLine."Line No.",
                    SalesLine."Qty. per Unit of Measure",
                    assignqty,
                    assignqty
                    , TempReservationEntry);
                    CreatereservationEntry.CreateEntry(SalesLine."No.", '', SalesLine."Location Code",
                   SalesLine.Description, 0D, SalesLine."Shipment Date", 0, Enum::"Reservation Status"::Surplus);
                until (i >= SalesLine.Quantity) OR (ItemLedgerEntry.Next() = 0);
            until SalesLine.Next() = 0;
    end;

}
