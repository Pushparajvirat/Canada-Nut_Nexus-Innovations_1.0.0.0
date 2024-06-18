pageextension 50132 "Item Tracking Spec Ext" extends "Item Tracking Lines"
{
    layout
    {
        addafter("Expiration Date")
        {
            field("Country Of Origin"; Rec."Country Of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country Of Origin field.';
            }
            field("Status Code"; Rec."Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status Code field.';
            }
            field("Pallet No."; Rec."Pallet No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pallet No. field.';
            }
            field("Net Weight"; Rec."Net Weight")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Net Weight field.';
            }
            field("Production Date"; Rec."Production Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Production Date field.';
            }
        }
    }
}
