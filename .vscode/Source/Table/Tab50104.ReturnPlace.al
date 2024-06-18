table 50104 "Return Place"
{
    Caption = 'Return Place';
    DataClassification = ToBeClassified;
    LookupPageId = "Return Location";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Return Location"; Text[50])
        {
            Caption = 'Return Location';
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
