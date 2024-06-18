table 50102 Incoterm
{
    Caption = 'Incoterm';
    DataClassification = ToBeClassified;
    LookupPageId = Incoterm;

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
