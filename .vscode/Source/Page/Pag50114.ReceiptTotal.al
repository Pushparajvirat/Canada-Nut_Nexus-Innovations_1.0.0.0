page 50114 "Receipt Total"
{
    ApplicationArea = All;
    Caption = 'Receipt Total';
    PageType = CardPart;
    SourceTable = "Sales Header";

    layout
    {
        area(Content)
        {
            field(Amount; Rec.Amount)
            {
                ApplicationArea = all;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = All;
                AboutTitle = 'Remember TAX';
                AboutText = 'This total is including vat/tax/moms/gst/pst/hst';
            }
        }
    }
}
