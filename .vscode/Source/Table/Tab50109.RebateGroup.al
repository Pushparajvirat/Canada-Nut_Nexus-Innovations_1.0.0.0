table 50109 "Rebate Group"
{
    Caption = 'Rebate Group';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Rebate Accural Account"; Code[20])
        {
            Caption = 'Rebate Accural Account';
            TableRelation = "G/L Account"."No.";
        }
        field(5; "Rebate Expense Account"; Code[20])
        {
            Caption = 'Rebate Expense Account';
            TableRelation = "G/L Account"."No.";
        }
        field(6; "Rebate Discount Account"; Code[20])
        {
            Caption = 'Rebate Discount Account';
            TableRelation = "G/L Account"."No.";
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
