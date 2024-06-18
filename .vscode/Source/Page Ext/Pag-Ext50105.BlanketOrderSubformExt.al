pageextension 50105 "Blanket Order Subform Ext" extends "Blanket Purchase Order Subform"
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
            field("Price Per Pound"; Rec."Price Per Pound")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Pound field.';
            }
        }
        addlast(Control15)
        {
            field(WeightLBS; WeightLBS)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Weight in LBS field.';
                Editable = false;
                Caption = 'Total Weight in LB';
            }
            field(WeightInKG; WeightInKG)
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
        addafter("Line Amount")
        {
            field("Advance Amount"; Rec."Advance Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Amount field.';
                Editable = false;
            }
            field("Advance Voucher No."; Rec."Advance Voucher No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Voucher No. field.';
                Editable = false;
            }
            field("Adv. Reversal Posted"; Rec."Adv. Reversal Posted")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Adv. Reversal Posted field.';
                Editable = false;
            }
            field("Amount Paid New"; Rec."Amount Paid New")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Advance Amount Paid field.';
                Editable = false;
            }
            field("Rec Amt Voucher No."; Rec."Rec Amt Voucher No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Payment Voucher No. field.';
                Editable = false;
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
        modify("Direct Unit Cost")
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
        WeightInKG: Decimal;


    procedure UpdateTotal()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        WeightLBS := 0;
        ContractQty := 0;
        TotalBalanceQty := 0;
        TotalOrderQty := 0;
        PricePerPound := 0;
        WeightInKG := 0;
        PurchaseLine.Reset();
        PurchaseLine.CopyFilters(Rec);
        PurchaseLine.CalcSums("Weight in LBS");
        PurchaseLine.CalcSums(Quantity);
        PurchaseLine.CalcSums("Order Qty.");
        PurchaseLine.CalcSums("Balance Qty.");
        PurchaseLine.CalcSums("Price Per Pound");
        PurchaseLine.CalcSums("Weight in KG");
        WeightLBS := PurchaseLine."Weight in LBS";
        ContractQty := PurchaseLine.Quantity;
        TotalOrderQty := PurchaseLine."Order Qty.";
        TotalBalanceQty := PurchaseLine."Balance Qty.";
        PricePerPound := PurchaseLine."Price Per Pound";
        WeightInKG := PurchaseLine."Weight in KG";
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
