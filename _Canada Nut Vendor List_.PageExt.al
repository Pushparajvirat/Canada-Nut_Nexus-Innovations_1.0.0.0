pageextension 50101 "Canada Nut Vendor List" extends "Vendor List"
{
    layout
    {
        addbefore("Balance (LCY)")
        {
            field(Balance; Rec.Balance)
            {
                ApplicationArea = All;
                Caption = 'Balance';
                ToolTip = 'Balance';
                Editable = false;
            }
        }
        modify("Currency Code")
        {
            Caption = 'Currency';
            ToolTip = 'Currency';
            Visible = true;
        }
        moveafter(Balance; "Currency Code")
    }
}
