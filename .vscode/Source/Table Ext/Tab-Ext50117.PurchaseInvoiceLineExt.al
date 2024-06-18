tableextension 50117 PurchaseInvoiceLineExt extends "Purch. Inv. Line"
{
    fields
    {
        field(50111; "Advance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance Amount';
        }
        field(50110; "Advance Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance Voucher No.';
        }
        field(50112; "Adv. Reversal Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Advance Reversed';
        }
        field(50113; "Rec Amt Voucher No."; Code[20])
        {
            Caption = 'Payment Voucher No.';
        }
        field(50114; "Amount Paid New"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance Amount Paid';
        }
    }
}
