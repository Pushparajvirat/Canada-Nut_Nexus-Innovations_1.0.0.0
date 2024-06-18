page 50112 "POS Setup"
{
    Caption = 'POS Setup';
    SourceTable = "POS Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    PageType = Card;
    layout
    {
        area(Content)
        {
            field("Cash Customer"; Rec."Cash Customer")
            {
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.isempty() then
            Rec.insert();
    end;
}
