pageextension 50113 "Sales Order Subform Ext" extends "Sales Order Subform"
{
    layout
    {
        modify("No.")
        {
            AssistEdit = true;
            trigger OnAssistEdit()
            var
                ItemAvailability: Page "Item Availability";
                Item: Record Item;
                SL: Record "Sales Line";
                LineNo: Integer;
            begin
                ItemAvailability.LookupMode := true;
                if ItemAvailability.RunModal() = Action::LookupOK then begin
                    SL.Setrange("Document No.", Rec."Document No.");
                    SL.SetRange("Document Type", REc."Document Type");
                    if SL.FindLast() then
                        LineNo := SL."Line No.";

                    Item.Setfilter("No.", ItemAvailability.GetSelectionFilter());
                    if Item.FindSet() then
                        repeat
                            LineNo += 10000;
                            SL.Init();
                            SL."Document Type" := Rec."Document Type";
                            SL."Document No." := Rec."Document No.";
                            SL."Line No." := LineNo;
                            SL.Insert(true);
                            SL.Validate(Type, SL.Type::Item);
                            SL.Validate("No.", Item."No.");
                            SL.Validate(Quantity, 1);
                            SL.ShowReservation();
                            SL.Modify(true);
                        until Item.Next() = 0;
                    CurrPage.Update(false);
                end;
            end;
        }
        modify("Unit Price")
        {
            Editable = UnitCostEditable;
        }
        modify("Line Amount")
        {
            Editable = UnitCostEditable;
        }
        modify("Net Weight")
        {
            trigger OnAfterValidate()
            var
                TotalAmount: Decimal;
            begin
                If Rec."Unit of Measure Code" = 'CS' then begin
                    TotalAmount := Rec."Net Weight" * Rec."Price Per Kg";
                    Rec.Validate("Unit Price", (TotalAmount / Rec.Quantity));
                end else
                    Rec.Validate("Unit Price", Rec."Price Per Kg");
                ForceTotalsCalculation();
                CurrPage.Update(true);
            end;
        }
        addafter(Quantity)
        {
            field("Minimum Order Qty."; Rec."Minimum Order Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Minimum Order Qty. field.';
            }
        }
        addafter("Shipment Date")
        {
            field("ETD Date"; Rec."ETD Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ETD field.';
            }
            field("Material Cost"; Rec."Material Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Material Cost field.';
                Visible = true;
            }
            field("Freight Cost"; Rec."Freight Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Freight Cost field.';
                Visible = true;
            }
            field("Landed Cost"; Rec."Landed Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Landed Cost field.';
                Visible = true;
            }
        }
        addafter("Unit Price")
        {
            field("Price Per Kg"; Rec."Price Per Kg")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Price Per Kg field.';
                trigger OnValidate()
                var
                    TotalAmount: Decimal;
                begin
                    If Rec."Unit of Measure Code" = 'CS' then begin
                        TotalAmount := Rec."Net Weight" * Rec."Price Per Kg";
                        Rec.Validate("Unit Price", (TotalAmount / Rec.Quantity));
                    end else
                        Rec.Validate("Unit Price", Rec."Price Per Kg");
                    ForceTotalsCalculation();
                    CurrPage.Update(true);
                end;
            }
        }
        addafter("Line Amount")
        {
            field("Rebate Amount"; Rec."Rebate Amount")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Rebate Amount field.';
            }
        }
        addlast(Control28)
        {
            field(TotalRebate; TotalRebate)
            {
                Caption = 'Rebate Total';
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Blanket Order No." <> '' then begin
            UnitCostEditable := false;
        end else
            UnitCostEditable := true;

    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec."Blanket Order No." <> '' then begin
            UnitCostEditable := false;
        end else
            UnitCostEditable := true;
        updateTotal();
    end;

    trigger OnOpenPage()
    begin
        if Rec."Blanket Order No." <> '' then begin
            UnitCostEditable := false;
        end else
            UnitCostEditable := true;
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
        UnitCostEditable: Boolean;
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
