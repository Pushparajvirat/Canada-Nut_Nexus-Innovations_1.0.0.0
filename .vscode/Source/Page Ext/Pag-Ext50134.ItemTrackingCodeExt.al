pageextension 50134 "Item Tracking Code Ext" extends "Item Tracking Code Card"
{
    layout
    {
        addlast(Inbound)
        {
            field("Strict Country Of Origin"; Rec."Strict Country Of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Strict Country Of Origin field.';
            }
        }
    }
}
