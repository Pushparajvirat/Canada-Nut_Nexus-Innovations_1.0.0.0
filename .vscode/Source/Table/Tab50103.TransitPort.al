table 50103 "Transit Port"
{
    Caption = 'Transit Port';
    DataClassification = ToBeClassified;
    LookupPageId = "Transit Port";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; "Port Name"; Text[50])
        {
            Caption = 'Port Name';
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
