pageextension 50106 "Blanket Purch. Ext" extends "Blanket Purchase Order"
{

    Caption = 'Purchase Contract';

    layout
    {
        addafter("Vendor Order No.")
        {
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Start Date field.';
            }
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the End Date field.';
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
            }
        }
        addafter("Shipping and Payment")
        {
            group(Prepayment)
            {
                Caption = 'Advance';
                field("Advance %"; Rec."Advance %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance % field.';
                }
                field("Advance Amount"; Rec."Advance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance Amount field.';
                }
                field("Advance Voucher No."; Rec."Advance Voucher No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Advance Voucher No. field.';
                }
            }
        }

    }
    actions
    {
        addafter("F&unctions")
        {
            action(CreateAdvanceInvoice)
            {
                ApplicationArea = All;
                Caption = 'Create & Post Advance';
                Promoted = true;
                PromotedCategory = Process;
                Image = CreateDocument;
                AccessByPermission = tabledata "Purch. Inv. Header" = rimd;
                trigger OnAction()
                var
                    RecPurchaseHeader: Record "Purchase Header";
                    PurchHeader: Record "Purchase Header";
                    PurchInvHeader: Record "Purch. Inv. Header";
                    PurchLine: Record "Purchase Line";
                    AdvInvNo: Code[20];
                    TotalAmount: Decimal;
                    PurchasePaySetup: Record "Purchases & Payables Setup";
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    AdvanceNo: Code[20];
                begin
                    PurchHeader.Get(Rec."Document Type", Rec."No.");
                    Clear(AdvInvNo);
                    Rec.TestField("Advance Voucher No.", '');
                    Rec.TestField("Advance Amount");
                    if Not Confirm('Do you want to Post the Advance Invoice with Amount %1', False, Rec."Advance Amount") then
                        exit;
                    PurchasePaySetup.Get();
                    PurchasePaySetup.TestField("Advance Unposted Series");
                    AdvanceNo := NoSeriesMgt.GetNextNo(PurchasePaySetup."Advance Unposted Series", Today, true);
                    Rec.CreateAdvanceInvoiceHeader(RecPurchaseHeader, AdvanceNo);
                    Rec.CreateAdvanceInvoiceLine(Rec."Advance Amount", RecPurchaseHeader."No.");
                    AdvInvNo := AdvanceNo;
                    Codeunit.Run(Codeunit::"Purch.-Post", RecPurchaseHeader);
                    PurchInvHeader.Reset();
                    PurchInvHeader.SetCurrentKey("Pre-Assigned No.");
                    PurchInvHeader.SetRange("Pre-Assigned No.", AdvInvNo);
                    if PurchInvHeader.FindFirst() then begin
                        PurchHeader."Advance Voucher No." := PurchInvHeader."No.";
                        PurchHeader.Modify();
                    End;
                    PurchLine.Reset();
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then begin
                        repeat
                            TotalAmount += PurchLine.Amount;
                        until PurchLine.Next = 0;
                    end;
                    PurchLine.Reset();
                    PurchLine.SetRange("Document Type", Rec."Document Type");
                    PurchLine.SetRange("Document No.", Rec."No.");
                    if PurchLine.FindSet() then
                        repeat
                            PurchLine."Advance Voucher No." := PurchHeader."Advance Voucher No.";
                            if PurchHeader."Advance Amount" > 0 then
                                PurchLine."Advance Amount" := Round((PurchLine.Amount / TotalAmount * PurchHeader."Advance Amount"), 0.01);
                            PurchLine.Modify();
                        until PurchLine.Next() = 0;
                    Message('Advance Invoice No. %1 created Sucessfully & Posted Successfully', AdvInvNo);
                end;
            }
            action(RevrseAdvInvoice)
            {
                ApplicationArea = All;
                Caption = 'Reverse Advance Invoice';
                Promoted = true;
                PromotedCategory = Process;
                Image = CreateDocument;
                trigger OnAction()
                var
                    NewPurchaseHdr: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    PurchaseHead: Record "Purchase Header";
                    PurchInvHeader: Record "Purch. Inv. Header";
                    CopyDocumentMgt: Codeunit "Copy Document Mgt.";
                    CorrectPostedPurchaseInvoice: Codeunit "Correct Posted Purch. Invoice";
                begin
                    PurchaseHead.get(Rec."Document Type", Rec."No.");
                    If Not Confirm('Do you want to Reverse Posted Advance Invoice', false) then
                        exit;
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", Rec."Document Type");
                    PurchaseLine.SetRange("Document No.", Rec."No.");
                    if PurchaseLine.FindSet() then
                        repeat
                            PurchaseLine.TestField("Adv. Reversal Posted", false);
                        Until PurchaseLine.Next() = 0;
                    Rec.TestField("Advance Voucher No.");
                    PurchInvHeader.get(Rec."Advance Voucher No.");
                    CorrectPostedPurchaseInvoice.CreateCreditMemoCopyDocument(PurchInvHeader, NewPurchaseHdr);
                    NewPurchaseHdr."Vendor Cr. Memo No." := Rec."Advance Voucher No." + '/CAN';
                    NewPurchaseHdr."Applies-to Doc. Type" := NewPurchaseHdr."Applies-to Doc. Type"::Invoice;
                    NewPurchaseHdr."Applies-to Doc. No." := Rec."Advance Voucher No.";
                    NewPurchaseHdr."Posting Date" := Rec."Order Date";
                    Codeunit.Run(Codeunit::"Purch.-Post", NewPurchaseHdr);
                    PurchaseHead."Advance Voucher No." := '';
                    PurchaseHead."Advance Amount" := 0;
                    PurchaseHead."Advance %" := 0;
                    PurchaseHead.Modify();
                    PurchaseLine.Reset();
                    PurchaseLine.SetRange("Document Type", PurchaseHead."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHead."No.");
                    if PurchaseLine.FindSet() then
                        repeat
                            PurchaseLine."Advance Voucher No." := '';
                            PurchaseLine."Advance Amount" := 0;
                            PurchaseLine.Modify();
                        until PurchaseLine.Next() = 0;
                    Message('Advance Invoice Reversed Successfully');
                End;
            }

        }
        addafter(MakeOrder)
        {
            action("Update Advance Received")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Caption = 'Update Advance Paid';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    Rec.updateAdvanceAmount();
                end;
            }
        }
    }
}
