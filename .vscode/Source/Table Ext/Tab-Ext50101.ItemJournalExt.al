tableextension 50101 "Item Journal Ext" extends "Item Journal Line"
{
    fields
    {
        field(50100; "Estimated Qty"; Decimal)
        {
            Caption = 'Estimated Qty';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; Variance; Decimal)
        {
            Caption = 'Variance';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Qty. in Pallet"; Decimal)
        {
            Caption = 'Qty. in Pallet';
            DataClassification = ToBeClassified;
        }
        field(50103; "Country Of Origin"; Code[20])
        {
            Caption = 'Country Of Origin';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50106; "Price Per SUOM"; Decimal)
        {
            Caption = 'Price Per SUOM';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50107; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Status Code"; Code[20])
        {
            Caption = 'Staus Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
