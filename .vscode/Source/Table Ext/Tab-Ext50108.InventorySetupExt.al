tableextension 50108 "Inventory Setup Ext" extends "Inventory Setup"
{
    fields
    {
        field(50100; "Reclas. Journal Template"; Code[10])
        {
            Caption = 'Reclassification Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Template".Name;
        }
        field(50101; "Reclassification Journal Batch"; Code[10])
        {
            Caption = 'Reclassification Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Item Journal Batch".Name where("Journal Template Name" = field("Reclas. Journal Template"));
        }
        field(50102; "Reclas. No. Series"; Code[10])
        {
            Caption = 'Reclassification No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
    }
}
