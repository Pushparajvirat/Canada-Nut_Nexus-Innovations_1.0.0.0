pageextension 50109 "Purch. Order Subform Ext" extends "Purchase Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field(PurchaseUOM; Rec.PurchaseUOM)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Voucher No. field.';
            }
            field("Weight in LBS"; Rec."Weight in LBS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LBS field.';
            }
            field("Weight in KG"; Rec."Weight in KG")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in KG field.';
            }
            field("Price Per Pound"; Rec."Price Per Pound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Pound field.';
            }
            field("Coutry of Origin"; Rec."Country of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Coutry of Origin field.';
            }
            field("Status Code"; Rec."Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status Code field.';
            }
        }
        modify("Direct Unit Cost")
        {
            Editable = DirectCostEditable;
        }
        modify("Line Amount")
        {
            Editable = DirectCostEditable;
        }
        addafter(Description)
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
        }
        modify("Net Weight")
        {
            trigger OnAfterValidate()
            var
                TotalAmount: Decimal;
            begin
                If Rec."Unit of Measure Code" = 'CS' then begin
                    TotalAmount := Rec."Net Weight" * Rec."Price Per Kg";
                    Rec.Validate("Direct Unit Cost", (TotalAmount / Rec.Quantity));
                end else
                    Rec.Validate("Direct Unit Cost", Rec."Price Per Kg");
                ForceTotalsCalculation();
                CurrPage.Update(true);
            end;
        }
        addafter("Requested Receipt Date")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ETD Date field.';
            }
        }
        addafter("Direct Unit Cost")
        {
            field("Price Per Kg"; Rec."Price Per Kg")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Kg field.';
                trigger OnValidate()
                var
                    TotalAmount: Decimal;
                begin
                    If Rec."Unit of Measure Code" = 'CS' then begin
                        TotalAmount := Rec."Net Weight" * Rec."Price Per Kg";
                        Rec.Validate("Direct Unit Cost", (TotalAmount / Rec.Quantity));
                    end else
                        Rec.Validate("Direct Unit Cost", Rec."Price Per Kg");
                    ForceTotalsCalculation();
                    CurrPage.Update(true);
                end;
            }
        }
    }
    actions
    {
        addafter("Item Tracking Lines")
        {
            action(AssignLotNos)
            {
                ApplicationArea = All;
                Caption = 'Assign Lot No''s';
                Image = Lot;
                trigger OnAction()
                var
                    ItemRec: Record Item;
                    PurchaseLine: Record "Purchase Line";
                    ReservationEntry: Record "Reservation Entry";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    LotNo: Code[20];
                    ItemExistErr: Label 'Please Select Item No.';
                    ItemErr: Label 'Type Should be Item';
                    NothingtoCreateErr: Label 'Nothing to Create.';
                    LotNoExistErr: Label 'Lot Information already exist for Line %1';
                begin
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", Rec."Document Type");
                    PurchaseLine.SetRange("Document No.", Rec."Document No.");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    if PurchaseLine.FindSet() then begin
                        repeat
                            PurchaseLine.TestField("Country of Origin");
                            PurchaseLine.TestField("Status Code");
                            if PurchaseLine.Type <> PurchaseLine.Type::Item then
                                Error(ItemErr);

                            if PurchaseLine."No." = '' then
                                Error(ItemExistErr);

                            ReservationEntry.Reset();
                            ReservationEntry.SetRange("Source Type", 39);
                            ReservationEntry.SetRange("Source Subtype", 1);
                            ReservationEntry.SetRange("Source ID", PurchaseLine."Document No.");
                            ReservationEntry.SetRange("Source Ref. No.", PurchaseLine."Line No.");
                            ReservationEntry.SetRange("Item No.", PurchaseLine."No.");
                            ReservationEntry.SetRange("Variant Code", Rec."Variant Code");
                            if not ReservationEntry.FindFirst() then begin
                                ItemRec.Get(PurchaseLine."No.");
                                clear(NoSeriesMgt);
                                LotNo := PurchaseLine."Lot No.";
                                Rec.CreateReservationEntry(PurchaseLine."No.", PurchaseLine."Location Code", PurchaseLine."Quantity (Base)", 39, 1, PurchaseLine.Description,
                                        PurchaseLine."Document No.", PurchaseLine."Line No.", PurchaseLine."Qty. per Unit of Measure", PurchaseLine."Quantity (Base)", LotNo, true, '', 2, 0D, PurchaseLine."Variant Code", PurchaseLine."Country of Origin", PurchaseLine."Net Weight", PurchaseLine."Status Code");
                            end else begin
                                if Confirm('Item Tracking is already created for %1 and Line No. %2/ Do you still want to Create a New one?', false, PurchaseLine."No.", PurchaseLine."Line No.") then begin
                                    ReservationEntry.DeleteAll(true);
                                    ItemRec.Get(Rec."No.");
                                    clear(NoSeriesMgt);
                                    LotNo := Rec."Lot No.";
                                    Rec.CreateReservationEntry(Rec."No.", Rec."Location Code", Rec."Quantity (Base)", 39, 1, Rec.Description,
                                            Rec."Document No.", Rec."Line No.", Rec."Qty. per Unit of Measure", Rec.Quantity, LotNo, true, '', 2, 0D, PurchaseLine."Variant Code", PurchaseLine."Country of Origin", Rec."Net Weight", Rec."Status Code");
                                end;
                            end;
                        Until PurchaseLine.Next() = 0;
                    end else
                        Error(NothingtoCreateErr);
                end;
            }
            action(AssignLotNo)
            {
                ApplicationArea = All;
                Caption = 'Assign Lot No.';
                Image = Lot;
                trigger OnAction()
                var
                    ItemRec: Record Item;
                    PurchaseLine: Record "Purchase Line";
                    ReservationEntry: Record "Reservation Entry";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    LotNo: Code[20];
                    ItemExistErr: Label 'Please Select Item No.';
                    ItemErr: Label 'Type Should be Item';
                    NothingtoCreateErr: Label 'Nothing to Create.';
                    LotNoExistErr: Label 'Lot Information already exist for Line %1';
                    Confirm: Dialog;
                begin
                    if Rec.Type <> Rec.Type::Item then
                        Error(ItemErr);
                    if Rec."No." = '' then
                        Error(ItemExistErr);
                    Rec.TestField("Country of Origin");
                    Rec.TestField("Status Code");
                    ReservationEntry.Reset();
                    ReservationEntry.SetRange("Source Type", 39);
                    ReservationEntry.SetRange("Source Subtype", 1);
                    ReservationEntry.SetRange("Source ID", Rec."Document No.");
                    ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
                    ReservationEntry.SetRange("Item No.", Rec."No.");
                    ReservationEntry.SetRange("Variant Code", Rec."Variant Code");
                    if not ReservationEntry.FindFirst() then begin
                        ItemRec.Get(Rec."No.");
                        clear(NoSeriesMgt);
                        LotNo := Rec."Lot No.";
                        Rec.CreateReservationEntry(Rec."No.", Rec."Location Code", Rec."Quantity (Base)", 39, 1, Rec.Description,
                                Rec."Document No.", Rec."Line No.", Rec."Qty. per Unit of Measure", Rec.Quantity, LotNo, true, '', 2, 0D, Rec."Variant Code", Rec."Country of Origin", Rec."Net Weight", Rec."Status Code");
                    end else begin
                        if Confirm('Item Tracking is already created for %1 and Line No. %2/ Do you still want to Create a New one?', false, Rec."No.", Rec."Line No.") then begin
                            ReservationEntry.DeleteAll(true);
                            ItemRec.Get(Rec."No.");
                            clear(NoSeriesMgt);
                            LotNo := Rec."Lot No.";
                            Rec.CreateReservationEntry(Rec."No.", Rec."Location Code", Rec."Quantity (Base)", 39, 1, Rec.Description,
                                    Rec."Document No.", Rec."Line No.", Rec."Qty. per Unit of Measure", Rec.Quantity, LotNo, true, '', 2, 0D, Rec."Variant Code", Rec."Country of Origin", Rec."Net Weight", Rec."Status Code");
                        end;
                    end;
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Blanket Order No." <> '' then begin
            DirectCostEditable := false;
        end else
            DirectCostEditable := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Blanket Order No." <> '' then begin
            DirectCostEditable := false;
        end else
            DirectCostEditable := true;
    end;

    trigger OnOpenPage()
    begin
        if Rec."Blanket Order No." <> '' then begin
            DirectCostEditable := false;
        end else
            DirectCostEditable := true;
    end;

    var
        DirectCostEditable: Boolean;


}
