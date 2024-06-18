tableextension 50118 PurchaseInvoiceHeaderExt extends "Purch. Inv. Header"
{
    fields
    {
        field(50136; "Advance Voucher No."; Code[20])
        {
            Caption = 'Advance Voucher No.';
            DataClassification = ToBeClassified;
        }
        field(50137; "Advance Amount"; Decimal)
        {
            Caption = 'Advance Amount';
            DataClassification = ToBeClassified;
        }
        field(50138; "Advance Invoice"; boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Advance Invoice';
        }
        field(50139; "Advance %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance %';
            trigger OnValidate()
            begin
                TestField("Advance Voucher No.", '');
                CalcFields(Amount);
                Rec."Advance Amount" := (Rec.Amount * Rec."Advance %") / 100;
            end;
        }
    }
}
