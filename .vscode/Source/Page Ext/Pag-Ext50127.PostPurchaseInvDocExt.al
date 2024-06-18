pageextension 50127 PostPurchaseInvDocExt extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Shipping and Payment")
        {
            field("Advance %"; Rec."Advance %")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance % field.';
            }
            field("Advance Amount"; Rec."Advance Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Amount field.';
            }
            field("Advance Invoice"; Rec."Advance Invoice")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Invoice field.';
            }
            field("Advance Voucher No."; Rec."Advance Voucher No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Voucher No. field.';
            }
        }
    }
}
