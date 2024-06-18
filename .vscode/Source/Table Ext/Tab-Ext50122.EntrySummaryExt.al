tableextension 50122 "Entry Summary Ext" extends "Entry Summary"
{
    fields
    {
        field(50100; "Country Of Origin"; Code[20])
        {
            Caption = 'Country Of Origin';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Status Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status Code';
            Editable = false;
        }
    }
}
