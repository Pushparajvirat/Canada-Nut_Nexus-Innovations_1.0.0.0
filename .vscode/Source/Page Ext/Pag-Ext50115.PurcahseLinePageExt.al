pageextension 50115 "Purcahse Line Page Ext" extends "Purchase Lines"
{

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            LookupOKOnPush();
    end;

    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        UnitCost: Decimal;
        FromPurchaseLine: Record "Purchase Line";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        AssignItem: Codeunit "Item Charge Assigment Codeunit";

    procedure Initialize(NewItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; NewUnitCost: Decimal)
    begin
        ItemChargeAssgntPurch := NewItemChargeAssgntPurch;
        UnitCost := NewUnitCost;
    end;

    local procedure LookupOKOnPush()
    begin
        FromPurchaseLine.Copy(Rec);
        CurrPage.SetSelectionFilter(FromPurchaseLine);
        if FromPurchaseLine.FindFirst() then begin
            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
            AssignItem.CreateRcptChargeAssgnt(FromPurchaseLine, ItemChargeAssgntPurch);
        end;
    end;
}
