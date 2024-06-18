page 50121 "Rebate List"
{
    ApplicationArea = All;
    Caption = 'Rebate List';
    PageType = List;
    SourceTable = "Rebate Header";
    UsageCategory = Lists;
    CardPageId = Rebate;
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
            }
        }
    }
}
