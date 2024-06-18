page 50122 "Rebate Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Rebate Ledger Entries';
    PageType = List;
    SourceTable = "Rebate Ledger Entry";
    UsageCategory = ReportsAndAnalysis;
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Item Category Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Rebate Code"; Rec."Rebate Code")
                {
                    ToolTip = 'Specifies the value of the Rebate Code field.';
                }
                field("Rebate Amount"; Rec."Rebate Amount")
                {
                    ToolTip = 'Specifies the value of the Rebate Amount field.';
                }
                field("Invoice Line Amount"; Rec."Invoice Line Amount")
                {
                    ToolTip = 'Specifies the value of the Invoice Line Amount field.';
                }
                field("Rebate Expense Account"; Rec."Rebate Expense Account")
                {
                    ToolTip = 'Specifies the value of the Invoice Line Amount field.';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field("Rebate Posted"; Rec."Rebate Posted")
                {
                    ToolTip = 'Specifies the value of the Rebate Posted field.';
                }
            }
        }
    }
}
