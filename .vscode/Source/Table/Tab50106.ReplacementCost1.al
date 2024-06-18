table 50106 "Replacement Cost1"
{
    Caption = 'ReplaceMent Cost';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                Item.Reset();
                Item.SetRange("No.", Rec."Item No.");
                if Item.FindFirst() then begin
                    if Not Item."Avail Replacement Cost" then
                        Error('You cannot use this item for Replacement Cost')
                    else begin
                        Rec.Description := Item.Description;
                        Rec."Unit Cost" := Item."Unit Cost";
                    end;
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(4; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;
        }
        field(5; "Replacement Cost"; Decimal)
        {
            Caption = 'Replacement Cost';
        }
        field(6; "Line No."; Integer)
        {
            Caption = 'Replacement Cost';
        }
    }
    keys
    {
        key(PK; "Item No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
