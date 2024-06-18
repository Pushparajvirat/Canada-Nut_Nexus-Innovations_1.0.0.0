table 50105 "ReplaceMent Cost"
{
    Caption = 'ReplaceMent Cost';
    DataClassification = ToBeClassified;
    ObsoleteState = Removed;
    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            Editable = false;
            trigger OnValidate()
            var
                Item: Record Item;
            begin
                Item.Reset();
                Item.SetRange("No.", Rec."Item No.");
                if Item.FindFirst() then begin
                    if Not Item."Avail Replacement Cost" then
                        Error('You cannot use this item for Replacement Cost')
                    else
                        exit;
                end;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
        }
        field(3; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(4; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Item."Unit Cost" where("No." = field("Item No.")));
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
        key(PK; "Item No.")
        {
            Clustered = true;
        }
    }
}
