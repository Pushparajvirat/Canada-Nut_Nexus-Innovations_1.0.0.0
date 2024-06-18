pageextension 50119 "Inventory Setup Ext" extends "Inventory Setup"
{
    layout
    {
        addafter("Package Nos.")
        {
            field("Reclas. Journal Template"; Rec."Reclas. Journal Template")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reclassification Journal Template field.';
            }
            field("Reclassification Journal Batch"; Rec."Reclassification Journal Batch")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reclassification Journal Batch field.';
            }
            field("Reclas. No. Series"; Rec."Reclas. No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reclassification No. Series field.';
            }
        }
    }
}
