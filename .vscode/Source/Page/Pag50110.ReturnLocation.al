page 50110 "Return Location"
{
    ApplicationArea = All;
    Caption = 'Return Location';
    PageType = List;
    SourceTable = "Return Place";
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
                field("Return Location"; Rec."Return Location")
                {
                    ToolTip = 'Specifies the value of the Return Location field.';
                }
            }
        }
    }
}
