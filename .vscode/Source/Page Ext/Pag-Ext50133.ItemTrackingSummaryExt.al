pageextension 50133 "Item Tracking Summary Ext" extends "Item Tracking Summary"
{
    layout
    {
        addafter("Package No.")
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
