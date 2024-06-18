pageextension 50122 "Item Led Entry Ext" extends "Item Ledger Entries"
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
        addafter("Lot No.")
        {
            field("Country Of Origin"; Rec."Country Of Origin")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Country Of Origin field.';
            }
            field("Status Code"; Rec."Status Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Staus Code field.';
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
            field("Price Per SUOM"; Rec."Price Per SUOM")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per SUOM field.';
            }
        }
        addafter("Expiration Date")
        {
            field("Production Date"; Rec."Production Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Production Date field.';
            }
        }
    }
}
