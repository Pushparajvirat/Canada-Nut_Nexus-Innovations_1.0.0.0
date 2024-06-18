pageextension 50111 BlanketSalesOrderExt extends "Blanket Sales Order"
{
    Caption = 'Sales Contract';

    layout
    {
        addafter("External Document No.")
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
    }
}
