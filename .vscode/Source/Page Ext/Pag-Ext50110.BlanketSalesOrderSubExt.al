pageextension 50110 BlanketSalesOrderSubExt extends "Blanket Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Order Qty."; Rec."Order Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Order Qty. field.';
                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                    UpdateTotal();
                end;
            }
            field("Balance Qty."; Rec."Balance Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Balance Qty. field.';
                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                    UpdateTotal();
                end;
            }
            field("Weight in LBS"; Rec."Weight in LBS")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LBS field.';
                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                    UpdateTotal();
                end;
            }
            field("Weight in KG"; Rec."Weight in KG")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in KG field.';
                trigger OnValidate()
                begin
                    CurrPage.SaveRecord();
                    UpdateTotal();
                end;
            }
            field("Minimum Order Qty."; Rec."Minimum Order Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Minimum Order Qty. field.';
            }
        }
        addlast(Control35)
        {
            field(WeightLBS; WeightLBS)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LBS field.';
                Editable = false;
                Caption = 'Total Weight in LB';
            }
            field(WeightKG; WeightKG)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in KG field.';
                Editable = false;
                Caption = 'Total Weight in KG';
            }
            field(ContractQty; ContractQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Contract Qty. field.';
                Editable = false;
                Caption = 'Contract Qty.';
            }
            field(TotalBalanceQty; TotalBalanceQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Balance Qty. field.';
                Editable = false;
                Caption = 'Total Balance Qty.';
            }
            field(TotalOrderQty; TotalOrderQty)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Total Order Qty. field.';
                Editable = false;
                Caption = 'Total Order Qty.';
            }
            field(PricePerPound; PricePerPound)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Pound field.';
                Editable = false;
                Caption = 'Price Per Pound';
            }
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                CurrPage.SaveRecord();
                UpdateTotal();
            end;
        }
        modify("Unit Price")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.SaveRecord();
                UpdateTotal();
            end;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.SaveRecord();
                UpdateTotal();
            end;
        }
    }
    var
        WeightLBS: Decimal;
        ContractQty: Decimal;
        TotalBalanceQty: Decimal;
        TotalOrderQty: Decimal;
        PricePerPound: Decimal;
        WeightKG: Decimal;


    procedure UpdateTotal()
    var
        SalesLine: Record "Sales Line";
    begin
        WeightKG := 0;
        WeightLBS := 0;
        ContractQty := 0;
        TotalBalanceQty := 0;
        TotalOrderQty := 0;
        PricePerPound := 0;
        SalesLine.Reset();
        SalesLine.CopyFilters(Rec);
        SalesLine.CalcSums("Weight in LBS");
        SalesLine.CalcSums(Quantity);
        SalesLine.CalcSums("Order Qty.");
        SalesLine.CalcSums("Balance Qty.");
        SalesLine.CalcSums("Price Per Pound");
        SalesLine.CalcSums("Weight in KG");
        WeightLBS := SalesLine."Weight in LBS";
        ContractQty := SalesLine.Quantity;
        TotalOrderQty := SalesLine."Order Qty.";
        TotalBalanceQty := SalesLine."Balance Qty.";
        PricePerPound := SalesLine."Price Per Pound";
        WeightKG := SalesLine."Weight in KG";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTotal();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdateTotal();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        UpdateTotal();
    end;
}
