table 50101 "Shipping Line"
{
    Caption = 'Shipping Line';
    DataClassification = ToBeClassified;
    LookupPageId = "Shipping Line";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
    }
}
