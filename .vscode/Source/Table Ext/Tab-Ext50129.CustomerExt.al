tableextension 50129 "Customer Ext" extends Customer
{
    fields
    {
        field(50100; "Rebate Group"; Code[20])
        {
            Caption = 'Rebate Group';
            DataClassification = ToBeClassified;
            TableRelation = "Rebate Group".Code;
        }
    }
}
