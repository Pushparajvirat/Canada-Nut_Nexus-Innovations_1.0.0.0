page 50113 "Select Payment Method"
{
    ApplicationArea = All;
    Caption = 'Select Payment Method';
    PageType = List;
    SourceTable = "Payment Method";
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            repeater(Rep)
            {
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
