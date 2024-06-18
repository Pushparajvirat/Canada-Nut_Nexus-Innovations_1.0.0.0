tableextension 50113 "Whse Shipment Line Ext" extends "Warehouse Shipment Line"
{
    fields
    {
        field(50100; "Qty. in Pallet"; Decimal)
        {
            Caption = 'Qty. in Pallet';
            DataClassification = ToBeClassified;
        }
    }
}
