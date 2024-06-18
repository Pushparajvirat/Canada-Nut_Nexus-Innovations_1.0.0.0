pageextension 50103 "Production Journal Ext" extends "Production Journal"
{
    layout
    {
        addafter(Quantity)
        {
            field("Estimated Qty"; Rec."Estimated Qty")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Estimated Qty field.';
            }
            field(Variance; Rec.Variance)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Variance field.';
            }
        }
    }
}
