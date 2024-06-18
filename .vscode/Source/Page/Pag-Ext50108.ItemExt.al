pageextension 50108 "Item Ext" extends "Item Card"
{
    layout
    {
        addafter("Common Item No.")
        {
            field("LB Conversion"; Rec."LB Conversion")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the LB Conversion field.';
            }
        }
        addafter(Inventory)
        {
            field("Weight in LB"; Rec."Weight in LB")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LB field.';
            }
            field("Qty. By Pallet"; Rec."Qty. By Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. By Pallet field.';
            }
            field("Inventory SUOM"; Rec."Inventory SUOM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inventory SUOM field.';
            }
        }
        addafter("Lot Nos.")
        {
            field("Lot Algorithm Code"; Rec."Lot Algorithm Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Algorithm Code field.';
            }
        }
        addafter("Indirect Cost %")
        {
            field("Sales Budget"; Rec."Sales Budget")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Budget field.';
            }
            field("Indirect Cost Amount"; Rec."Indirect Cost Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Indirect Cost Amount field.';
            }
        }
        addafter("Unit Cost")
        {
            field("Avail Replacement Cost"; Rec."Avail Replacement Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Avail Replacement Cost field.';
            }
            field("Replacement Cost."; Rec."Replacement Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Replacement Cost field.';
            }
        }
    }
    actions
    {
        addafter("Calc. Stan&dard Cost")
        {
            action("Replacement Cost")
            {
                Caption = 'Replacement Cost';
                Image = ListPage;
                Visible = Rec."Avail Replacement Cost";
                ApplicationArea = all;
                RunObject = page "Replacement Cost";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        ItemUOM.Reset();
        ItemUOM.SetRange("Item No.", Rec."No.");
        ItemUOM.SetRange(Code, 'LB');
        if ItemUOM.FindFirst() then begin
            Rec.CalcFields(Inventory);
            Rec."Weight in LB" := Rec.Inventory * ItemUOM."Qty. per Unit of Measure";
        end;
        GetDatafromothertable();
    end;

    trigger OnOpenPage()
    var
        ItemUOM: Record "Item Unit of Measure";
    begin
        ItemUOM.Reset();
        ItemUOM.SetRange("Item No.", Rec."No.");
        ItemUOM.SetRange(Code, 'LB');
        if ItemUOM.FindFirst() then begin
            Rec.CalcFields(Inventory);
            Rec."Weight in LB" := Rec.Inventory * ItemUOM."Qty. per Unit of Measure";
        end;
        GetDatafromothertable();
    end;

    Procedure GetDatafromothertable()
    var
        ReplacementCost: Record "Replacement Cost1";
    begin
        ReplacementCost.Reset();
        ReplacementCost.SetCurrentKey("Item No.", "Starting Date");
        ReplacementCost.SetAscending("Starting Date", true);
        ReplacementCost.SetRange("Item No.", Rec."No.");
        if ReplacementCost.FindLast() then
            Rec."Replacement Cost" := ReplacementCost."Replacement Cost";
    end;

}
