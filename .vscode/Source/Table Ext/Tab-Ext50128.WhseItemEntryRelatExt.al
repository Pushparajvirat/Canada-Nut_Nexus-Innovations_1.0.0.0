tableextension 50128 "Whse Item Entry Relat Ext" extends "Whse. Item Entry Relation"
{
    fields
    {
        field(50100; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "Country Of Origin"; Code[20])
        {
            Caption = 'Country Of Origin';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
    }
}
