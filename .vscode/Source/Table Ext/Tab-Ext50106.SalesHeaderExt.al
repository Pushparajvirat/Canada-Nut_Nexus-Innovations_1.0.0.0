tableextension 50106 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;
        }
        field(50101; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;
        }
        field(50102; "Total Weight By Line in LBS"; Decimal)
        {
            Caption = 'Total Weight By Line in LBS';
            DataClassification = ToBeClassified;
        }
        field(50104; "Weight in LBS"; Decimal)
        {
            Caption = 'Weight in LBS';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Weight in LBS" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50105; "Contract Qty."; Decimal)
        {
            Caption = 'Total Contract Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where("Document No." = field("No.")));
            Editable = false;
        }
        field(50106; "Total Order Qty."; Decimal)
        {
            Caption = 'Total Order Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Order Qty." where("Document No." = field("No.")));
            Editable = false;
        }
        field(50107; "Total Balance Qty."; Decimal)
        {
            Caption = 'Total Balance Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Balance Qty." where("Document No." = field("No.")));
            Editable = false;
        }
        field(50108; "Price Per Pound"; Decimal)
        {
            Caption = 'Price Per Pound';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Price Per Pound" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50109; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Sales Line"."Item Category Code" where("Document No." = field("No."), "Line No." = const(10000)));
            Editable = false;
        }
        field(50110; "ETD Date"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(50111; "Weight in KG"; Decimal)
        {
            Caption = 'Weight in KG';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Weight in KG" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50112; "Rebate Code"; Code[20])
        {
            Caption = 'Rebate Code';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
