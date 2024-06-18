pageextension 50117 "Sales Order Page Ext" extends "Sales Order"
{
    layout
    {
        addafter("Shipment Date")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ETD field.';
            }
            field("Rebate Code"; Rec."Rebate Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Code field.';
            }
        }
    }
}
