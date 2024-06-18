pageextension 50135 "Warehouse Entry Ext" extends "Warehouse Entries"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Pallet No."; Rec."Pallet No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pallet No. field.';
            }
        }
    }
}
