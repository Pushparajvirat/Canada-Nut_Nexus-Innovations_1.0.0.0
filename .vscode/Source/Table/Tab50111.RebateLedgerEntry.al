table 50111 "Rebate Ledger Entry"
{
    Caption = 'Rebate Ledger Entry';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(4; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Rebate Amount"; Decimal)
        {
            Caption = 'Rebate Amount';
        }
        field(7; "Rebate Posted"; Boolean)
        {
            Caption = 'Rebate Posted';
        }
        field(8; "Invoice Line Amount"; Decimal)
        {
            Caption = 'Invoice Line Amount';
        }
        field(9; "Rebate Expense Account"; Code[20])
        {
            Caption = 'Rebate Expense Account';
        }
        field(10; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
        }
        field(11; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(12; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
