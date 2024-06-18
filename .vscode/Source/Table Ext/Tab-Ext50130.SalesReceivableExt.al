tableextension 50130 "Sales & Receivable Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Rebate Nos."; Code[20])
        {
            Caption = 'Rebate Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50101; "Rebate Journal Template"; Code[10])
        {
            Caption = 'Rebate Journal Template';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50102; "Rebate Journal Batch"; Code[10])
        {
            Caption = 'Rebate Journal Batch';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Rebate Journal Template"));
        }
    }
}
