pageextension 50136 "Customer Ext" extends "Customer Card"
{
    layout
    {
        addlast(Invoicing)
        {
            field("Rebate Group"; Rec."Rebate Group")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Group field.';
            }
        }
    }
}
