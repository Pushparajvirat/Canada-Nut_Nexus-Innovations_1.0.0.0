pageextension 50120 "Warehouse Recipt Sub Ext" extends "Whse. Receipt Subform"
{
    layout
    {
        addafter("Qty. Outstanding")
        {
            field("Qty. in Pallet"; Rec."Qty. in Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. in Pallet field.';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Weight field.';
            }
        }
    }
}
