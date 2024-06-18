table 50107 "POS Setup"
{
    Caption = 'POS Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; POSKEY; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Cash Customer"; Code[18])
        {
            Caption = 'Cash Customer No.';
            TableRelation = Customer."No.";
        }
    }
}
