page 50119 "Rebate Subform"
{
    ApplicationArea = All;
    Caption = 'Rebate Subform';
    PageType = ListPart;
    SourceTable = "Rebate Lines";
    DelayedInsert = true;
    AutoSplitKey = true;
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item Category Code"; Rec."Sub-Type")
                {
                    ToolTip = 'Specifies the value of the Category Code field.';
                }
                field("Category Value"; Rec."Item Category Code")
                {
                    ToolTip = 'Specifies the value of the Value field.';
                }
                field("Category Description"; Rec."Category Description")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Calculation Base"; Rec."Calculation Base")
                {
                    ToolTip = 'Specifies the value of the Calculation Base field.';
                }
                field("Rebate Value"; Rec."Rebate Value")
                {
                    ToolTip = 'Specifies the value of the Rebate Value field.';
                }
            }
        }
    }
}
