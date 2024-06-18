pageextension 50121 "Stock Keeping Unit Ext" extends "Stockkeeping Unit Card"
{
    layout
    {
        addafter("Last Direct Cost")
        {
            field("Qty. By Pallet"; Rec."Qty. By Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. By Pallet field.';
            }
        }
    }
}
