pageextension 50123 "Transfer Order Subform" extends "Transfer Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Qty. in Pallet"; Rec."Qty. in Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. in Pallet field.';
            }
        }
    }
}
