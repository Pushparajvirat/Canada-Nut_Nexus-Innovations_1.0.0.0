table 50108 "Rebate Header"
{
    Caption = 'Rebate Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(3; "Rebate Type"; Option)
        {
            Caption = 'Rebate Type';
            OptionMembers = " ","Off-Invoice","Accural";
        }
        field(4; "Rebate Type Description"; Text[100])
        {
            Caption = 'Rebate Type Description';
        }
        field(5; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(6; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(7; "Calculation Base"; Option)
        {
            Caption = 'Calculation Base';
            OptionMembers = " ","Percentage(%)","Dollar($)";
        }
        field(8; "Rebate Group"; Code[20])
        {
            Caption = 'Rebate Group';
            TableRelation = "Rebate Group".Code;
            trigger OnValidate()
            var
                RebateGroup: Record "Rebate Group";
            begin
                if RebateGroup.Get(Rec."Rebate Group") then begin
                    Rec."Rebate Accural Account" := RebateGroup."Rebate Accural Account";
                    Rec."Rebate Expense Account" := RebateGroup."Rebate Expense Account";
                end;
            end;
        }
        field(9; "Rebate Accural Account"; Code[20])
        {
            Caption = 'Rebate Accural Account';
            TableRelation = "G/L Account"."No.";
        }
        field(10; "Rebate Expense Account"; Code[20])
        {
            Caption = 'Rebate Expense Account';
            TableRelation = "G/L Account"."No.";
        }
        field(11; "Rebate Discount Account"; Code[20])
        {
            Caption = 'Rebate Discount Account';
            TableRelation = "G/L Account"."No.";
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        NoseriesManagerMent: Codeunit NoSeriesManagement;
        SalesReceivable: Record "Sales & Receivables Setup";
    begin
        SalesReceivable.Get();
        Rec.Code := NoseriesManagerMent.GetNextNo(SalesReceivable."Rebate Nos.", Today, true);
    end;
}
