pageextension 50116 "Item List Ext" extends "Item List"
{
    layout
    {
        addafter(InventoryField)
        {
            field("In Transit Qty."; Rec."In Transit Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the In Transit Qty. field.';
            }
            field("In Process Qty."; Rec."In Process Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the In Process Qty. field.';
            }
            field("Purchase Contract Var"; Rec."Purchase Contract Var")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purchase Contract Qty. field.';
            }
            field("In Transit Sales Qty."; Rec."In Transit Sales Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the In Transit Sales Qty. field.';
            }
            field("In Process Sales Qty."; Rec."In Process Sales Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the In Process Sales Qty. field.';
            }
            field("Sales Contract Var"; Rec."Sales Contract Var")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Contract Qty. field.';
            }
            field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
            }
            field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
            }
            field("Sales Budget"; Rec."Sales Budget")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Budget field.';
            }
            field(AvailableItem; AvailableItem)
            {
                Caption = 'Available Inventory';
                ApplicationArea = all;
            }
            field(PositionQty; PositionQty)
            {
                Caption = 'Position Quantity';
                ApplicationArea = all;
            }
            field("Weight in LB"; Rec."Weight in LB")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LB field.';
            }
            field(InventoryValue; InventoryValue)
            {
                Caption = 'Inventory Value';
                ApplicationArea = all;
            }
            field(UnitCostPerLB; UnitCostPerLB)
            {
                Caption = 'Unit Cost Per LB';
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        GetDatafromItem();
    end;

    trigger OnAfterGetRecord()
    begin
        GetDatafromItem();
    end;

    var
        AvailableItem: Decimal;
        PositionQty: Decimal;
        InventoryValue: Decimal;
        UnitCostPerLB: Decimal;

    procedure GetDatafromItem()
    var
        Item: Record Item;
        ItemUOM: Record "Item Unit of Measure";
    begin
        Item.Reset();
        Item.SetRange("No.", Rec."No.");
        if Item.FindFirst() then begin
            AvailableItem := 0;
            PositionQty := 0;
            InventoryValue := 0;
            UnitCostPerLB := 0;
            Item.CalcFields("Qty. on Sales Order");
            Item.CalcFields(Inventory);
            AvailableItem := Item.Inventory - Item."Qty. on Sales Order";
            Item.CalcFields("In Process Qty.");
            Item.CalcFields("In Transit Qty.");
            Item.CalcFields("Purchase Contract Var");
            PositionQty := Item."In Process Qty." + Item."In Transit Qty." + Item."Purchase Contract Var";
            InventoryValue := Item.Inventory * Item."Unit Cost";
            ItemUOM.Reset();
            ItemUOM.SetRange("Item No.", Rec."No.");
            ItemUOM.SetRange(Code, 'LB');
            if ItemUOM.FindFirst() then begin
                Rec.CalcFields(Inventory);
                Rec."Weight in LB" := Rec.Inventory * ItemUOM."Qty. per Unit of Measure";
            end;
            if Rec."Weight in LB" <> 0 then
                UnitCostPerLB := InventoryValue / Rec."Weight in LB";
        end;
    end;
}
