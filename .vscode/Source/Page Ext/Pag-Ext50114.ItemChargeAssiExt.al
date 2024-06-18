pageextension 50114 "Item Charge Assi. Ext" extends "Item Charge Assignment (Purch)"
{
    actions
    {
        addafter(GetReceiptLines)
        {
            action(GetOrderLines)
            {
                AccessByPermission = TableData "Purch. Rcpt. Header" = R;
                ApplicationArea = ItemCharges;
                Caption = 'Get &Order Lines';
                Image = Receipt;
                ToolTip = 'Select a purchase Lines for the item that you want to assign the item charge to, for example, if you received an invoice for the item charge after you posted the original purchase receipt.';

                trigger OnAction()
                var
                    ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                begin
                    PurchLine2.TestField("Qty. to Invoice");

                    ItemChargeAssgntPurch.SetRange("Document Type", Rec."Document Type");
                    ItemChargeAssgntPurch.SetRange("Document No.", Rec."Document No.");
                    ItemChargeAssgntPurch.SetRange("Document Line No.", Rec."Document Line No.");
                    OpenPurchOrderLines(ItemChargeAssgntPurch);
                end;
            }
        }
    }

    local procedure OpenPurchOrderLines(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)")
    var
        PurchaseOrderLines: Page "Purchase Lines";
        PurchaseLine1: Record "Purchase Line";
    begin
        PurchaseLine1.Reset();
        PurchaseLine1.SetRange("Document Type", PurchaseLine1."Document Type"::Order);
        PurchaseLine1.SetRange(Type, PurchaseLine1.Type::Item);
        PurchaseOrderLines.SetTableView(PurchaseLine1);
        if ItemChargeAssignmentPurch.FindLast() then
            PurchaseOrderLines.Initialize(ItemChargeAssignmentPurch, PurchaseLine1."Unit Cost")
        else
            PurchaseOrderLines.Initialize(Rec, PurchaseLine1."Unit Cost");
        PurchaseOrderLines.LookupMode(true);
        PurchaseOrderLines.RunModal();
    end;
}
