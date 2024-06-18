tableextension 50127 "Postd Whse Receipt Line ext" extends "Posted Whse. Receipt Line"
{
    fields
    {
        field(50103; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            DataClassification = ToBeClassified;
        }
        field(50104; "Country Of Origin"; Code[20])
        {
            Caption = 'Country Of Origin';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
    }
}
