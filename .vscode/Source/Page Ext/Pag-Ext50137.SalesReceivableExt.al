pageextension 50137 "Sales & Receivable Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Rebate Nos."; Rec."Rebate Nos.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Nos. field.';
            }
        }
        addlast(General)
        {
            field("Rebate Journal Template"; Rec."Rebate Journal Template")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Journal Template field.';
            }
            field("Rebate Journal Batch"; Rec."Rebate Journal Batch")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Journal Batch field.';
            }
        }
    }
}
