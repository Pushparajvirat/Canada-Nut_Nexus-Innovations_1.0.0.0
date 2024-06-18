tableextension 50115 "Purchase & Payable Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "Advance Unposted Series"; Code[20])
        {
            Caption = 'Advance Unposted Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
            ValidateTableRelation = false;
        }
        field(50101; "Advance No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
            Caption = 'Advance No. Series';
            ValidateTableRelation = false;
        }
        field(50102; "Advance Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
            Caption = 'Advance Account';
            ValidateTableRelation = false;
        }
        field(50103; "Short Close PO"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Short Close PO';
        }
    }
}
