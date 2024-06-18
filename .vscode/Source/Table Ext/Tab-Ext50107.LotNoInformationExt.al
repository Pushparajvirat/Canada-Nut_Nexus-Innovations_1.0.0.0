tableextension 50107 "Lot No Information Ext" extends "Lot No. Information"
{
    fields
    {
        field(50100; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Ledger Entry"."Expiration Date" where("Lot No." = field("Lot No."), "Remaining Quantity" = filter('>0')));
        }
        field(50101; "New Expiration Date"; Date)
        {
            Caption = 'New Expiration Date';
            DataClassification = ToBeClassified;
        }
    }
}
