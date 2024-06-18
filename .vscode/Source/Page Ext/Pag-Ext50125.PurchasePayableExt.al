pageextension 50125 PurchasePayableExt extends "Purchases & Payables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Advance Account"; Rec."Advance Account")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Account field.';
            }
            field("Advance No. Series"; Rec."Advance No. Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance No. Series field.';
            }
            field("Advance Unposted Series"; Rec."Advance Unposted Series")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Unposted Series field.';
            }
        }
        addlast(General)
        {
            field("Short Close PO"; Rec."Short Close PO")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Short Close PO field.';
            }
        }
    }
}
