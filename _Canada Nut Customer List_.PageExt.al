pageextension 50100 "Canada Nut Customer List" extends "Customer List"
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
