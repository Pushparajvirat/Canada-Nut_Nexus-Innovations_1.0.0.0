pageextension 50129 "Payment Method Ext" extends "Payment Methods"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("POS Payment"; Rec."POS Payment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the POS Payment field.';
            }
        }
    }
}
