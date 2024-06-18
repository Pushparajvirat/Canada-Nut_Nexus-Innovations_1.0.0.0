page 50109 "Transit Port"
{
    ApplicationArea = All;
    Caption = 'Transit Port';
    PageType = List;
    SourceTable = "Transit Port";
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
                field("Port Name"; Rec."Port Name")
                {
                    ToolTip = 'Specifies the value of the Port Name field.';
                }
            }
        }
    }
}
