pageextension 50138 "Sales Credit Note Sub Ext" extends "Sales Cr. Memo Subform"
{
    layout
    {
        addafter("Line Amount")
        {
            field("Rebate Amount"; Rec."Rebate Amount")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control17)
        {
            field(TotalRebate; TotalRebate)
            {
                Caption = 'Rebate Total';
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        updateTotal();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateTotal();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        UpdateTotal();
    end;

    var
        TotalRebate: Decimal;

    procedure updateTotal()
    var
        SalesLine: Record "Sales Line";
    Begin
        TotalRebate := 0;
        SalesLine.Reset();
        SalesLine.CopyFilters(Rec);
        SalesLine.CalcSums("Rebate Amount");
        TotalRebate := SalesLine."Rebate Amount";
    End;
}
