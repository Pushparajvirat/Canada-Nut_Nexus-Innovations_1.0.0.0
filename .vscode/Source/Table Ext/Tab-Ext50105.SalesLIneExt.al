tableextension 50105 "Sales LIne Ext" extends "Sales Line"
{
    fields
    {
        field(50100; "Weight in LBS"; Decimal)
        {
            Caption = 'Weight in LBS';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Balance Qty."; Decimal)
        {
            Caption = 'Balance Qty.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Order Qty."; Decimal)
        {
            Caption = 'Order Qty.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Price Per Pound"; Decimal)
        {
            Caption = 'Price Per Pound';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Minimum Order Qty."; Decimal)
        {
            Caption = 'Minimum Order Qty.';
            DataClassification = ToBeClassified;
        }
        field(50105; "ETD Date"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(50106; "Weight in KG"; Decimal)
        {
            Caption = 'Weight in KG';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50107; "Material Cost"; Decimal)
        {
            Caption = 'Material Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50108; "Freight Cost"; Decimal)
        {
            Caption = 'Freight Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50109; "Landed Cost"; Decimal)
        {
            Caption = 'Landed Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50110; "Price Per Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Price Per Kg';
        }
        field(50111; "Rebate Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Rebate Amount';
            Editable = false;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Unit Price" <> 0 then
                    Rec."Price Per Pound" := (Rec."Weight in LBS" / Rec."Unit Price");
            end;
        }
        modify("Qty. to Ship")
        {
            trigger OnAfterValidate()
            begin
                If Rec."Minimum Order Qty." <> 0 then begin
                    If (Rec."Qty. to Ship" < Rec."Minimum Order Qty.") and (Rec."Qty. to Ship" <> 0) then
                        Error('Qty. to Ship Should greater than %1', Rec."Minimum Order Qty.");
                end;
            end;
        }
    }
}
