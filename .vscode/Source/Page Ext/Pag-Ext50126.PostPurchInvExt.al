pageextension 50126 PostPurchInvExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Advance Amount"; Rec."Advance Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Amount field.';
            }
            field("Advance Voucher No."; Rec."Advance Voucher No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Voucher No. field.';
            }
            field("Adv. Reversal Posted"; Rec."Adv. Reversal Posted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Reversed field.';
            }
            field("Rec Amt Voucher No."; Rec."Rec Amt Voucher No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Voucher No. field.';
            }
            field("Amount Paid New"; Rec."Amount Paid New")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Amount Paid field.';
            }
        }
    }
}
