pageextension 50112 "Blanker Sales Ord. List" extends "Blanket Sales Orders"
{
    Caption = 'Sales Contracts';
    layout
    {
        addafter(Status)
        {
            field("Start Date"; Rec."Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Start Date field.';
            }
            field("End Date"; Rec."End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the End Date field.';
            }
            field("Total Weight By Line in LBS"; Rec."Total Weight By Line in LBS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Weight By Line in LBS field.';
            }
            field("Weight in LBS"; Rec."Weight in LBS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LBS field.';
            }
            field("Weight in KG"; Rec."Weight in KG")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in KG field.';
            }
            field("Contract Qty."; Rec."Contract Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Contract Qty. field.';
            }
            field("Total Order Qty."; Rec."Total Order Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Order Qty. field.';
            }
            field("Total Balance Qty."; Rec."Total Balance Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Balance Qty. field.';
            }
            field("Price Per Pound"; Rec."Price Per Pound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Pound field.';
            }

            field("Buy-from Vendor Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Buy-from Vendor Name 2 field.';
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Item Category Code field.';
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the sum of amounts, including VAT, on all the lines in the document. This will include invoice discounts.';
            }
        }
    }
}
