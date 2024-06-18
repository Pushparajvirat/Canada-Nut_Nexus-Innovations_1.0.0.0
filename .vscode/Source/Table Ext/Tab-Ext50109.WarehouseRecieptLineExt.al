tableextension 50109 "Warehouse Reciept Line Ext" extends "Warehouse Receipt Line"
{
    fields
    {
        field(50100; "Qty. in Pallet"; Decimal)
        {
            Caption = 'Qty. in Pallet';
            DataClassification = ToBeClassified;
        }
        field(50101; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
        }
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
