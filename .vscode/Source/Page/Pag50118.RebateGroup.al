page 50118 "Rebate Group"
{
    ApplicationArea = All;
    Caption = 'Rebate Group';
    PageType = List;
    SourceTable = "Rebate Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
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
