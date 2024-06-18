tableextension 50111 "Item Led Entry Exr" extends "Item Ledger Entry"
{
    fields
    {
        field(50100; "Qty. in Pallet"; Decimal)
        {
            Caption = 'Qty. in Pallet';
            DataClassification = ToBeClassified;
        }
        field(50101; "Lot Sepcific Cost"; Decimal)
        {
            Caption = 'Lot Sepcific Cost';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost per Unit" where("Item Ledger Entry No." = field("Entry No."), "Document Type" = field("Document Type"), "Item Charge No." = filter(''), "Entry Type" = filter(<> 'Indirect Cost')));
        }
        field(50102; "Transport Cost"; Decimal)
        {
            Caption = 'Transport Cost';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost per Unit" where("Item Ledger Entry No." = field("Entry No."), "Document Type" = field("Document Type"), "Item Charge No." = filter(<> '')));
        }
        field(50103; "Indirect Cost"; Decimal)
        {
            Caption = 'Indirect Cost';
            FieldClass = FlowField;
            CalcFormula = sum("Value Entry"."Cost per Unit" where("Item Ledger Entry No." = field("Entry No."), "Document Type" = field("Document Type"), "Item Charge No." = filter(''), "Entry Type" = const("Indirect Cost")));
        }
        field(50104; "Country Of Origin"; Code[20])
        {
            Caption = 'Country Of Origin';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50106; "Production Date"; Date)
        {
            Caption = 'Production Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50107; "Price Per SUOM"; Decimal)
        {
            Caption = 'Price Per SUOM';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Pallet No."; Code[20])
        {
            Caption = 'Pallet No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50109; "Status Code"; Code[20])
        {
            Caption = 'Staus Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
