pageextension 50124 "Whse Ship Subform Ext" extends "Whse. Shipment Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Qty. in Pallet"; Rec."Qty. in Pallet")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Qty. in Pallet field.';
            }
        }
    }
}
