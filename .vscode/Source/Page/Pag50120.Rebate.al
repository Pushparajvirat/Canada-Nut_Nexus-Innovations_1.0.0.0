page 50120 Rebate
{
    ApplicationArea = All;
    Caption = 'Rebate';
    PageType = Document;
    SourceTable = "Rebate Header";
    UsageCategory = None;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ToolTip = 'Specifies the value of the Ending Date field.';
                }
                field("Rebate Type"; Rec."Rebate Type")
                {
                    ToolTip = 'Specifies the value of the Rebate Type field.';
                }
                field("Rebate Type Description"; Rec."Rebate Type Description")
                {
                    ToolTip = 'Specifies the value of the Rebate Type Description field.';
                }
                field("Calculation Base"; Rec."Calculation Base")
                {
                    ToolTip = 'Specifies the value of the Calculation Base field.';
                }
            }
            part(RebateSubform; "Rebate Subform")
            {
                Caption = 'Lines';
                ApplicationArea = all;
                SubPageLink = "Rebate Code" = field(Code);
            }
            group(Posting)
            {
                Caption = 'Posting';
                field("Rebate Group"; Rec."Rebate Group")
                {
                    ToolTip = 'Specifies the value of the Rebate Group field.';
                }
                field("Rebate Accural Account"; Rec."Rebate Accural Account")
                {
                    ToolTip = 'Specifies the value of the Rebate Accural Account field.';
                }
                field("Rebate Expense Account"; Rec."Rebate Expense Account")
                {
                    ToolTip = 'Specifies the value of the Rebate Expense Account field.';
                }
                field("Rebate Discount Account"; Rec."Rebate Discount Account")
                {
                    ToolTip = 'Specifies the value of the Rebate Discount Account field.';
                }
            }
        }
    }
}
