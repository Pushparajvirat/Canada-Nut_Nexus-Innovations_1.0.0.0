tableextension 50119 "Payment Method Ext" extends "Payment Method"
{
    fields
    {
        field(57100; "POS Payment"; Boolean)
        {
            Caption = 'POS Payment';
            DataClassification = SystemMetadata;
        }
    }
    keys
    {
        key(POS; "POS Payment")
        { }
    }
}
