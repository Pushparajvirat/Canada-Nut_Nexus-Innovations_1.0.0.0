table 50110 "Rebate Lines"
{
    Caption = 'Rebate Lines';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
        }
        field(2; "Line No"; Integer)
        {
            Caption = 'Line No';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            ObsoleteState = Removed;
        }
        field(4; "Sub-Type"; Option)
        {
            Caption = 'Sub-Type';
            OptionMembers = " ","Category Code";
        }
        field(5; "Item Category Code"; Code[20])
        {
            Caption = 'Value';
            TableRelation = "Item Category".Code;
            trigger OnValidate()
            var
                ItemCategory: Record "Item Category";
            begin
                if ItemCategory.Get(Rec."Item Category Code") then
                    Rec."Category Description" := ItemCategory.Description;
            end;
        }
        field(6; "Category Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Rebate Value"; Decimal)
        {
            Caption = 'Rebate Value';
        }
        field(8; "Calculation Base"; Option)
        {
            Caption = 'Calculation Base';
            OptionMembers = " ","Percentage(%)","Dollar($)";
        }
        field(9; "Category Value"; Code[20])
        {
            Caption = 'Category Value';
        }
    }
    keys
    {
        key(PK; "Rebate Code", "Line No")
        {
            Clustered = true;
        }
    }
}
