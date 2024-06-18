table 50100 "Shipment Type"
{
    Caption = 'Shipment Type';
    DataClassification = ToBeClassified;
    LookupPageId = "Shipment Type";

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
