report 50101 "Inventory Valuation Report"
{
    ApplicationArea = All;
    Caption = 'Detailed Inventory Valuation';
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/Source/Layouts/InventoryValuationNew.rdl';
    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            RequestFilterFields = "Item No.", "Lot No.", "Variant Code";
            column(Item_No_; "Item No.") { }
            column(Description; Descriptions) { }
            column(Lot_No_; "Lot No.") { }
            column(Variant_Code; "Variant Code") { }
            column(Remaining_Quantity; "Remaining Quantity") { }
            column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
            column(Cost_Amount__Actual___ACY_; "Cost Amount (Actual) (ACY)") { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Posting_Date; "Posting Date") { }
            column(RemainiQty; RemainiQty) { }
            column(ActualCost; ActualCost) { }
            column(CostingMethod; CostingMethod) { }
            column(Inventory_ValuationCaption; Inventory_ValuationCaptionLbl) { }
            column(CompanyInformation_Name; CompanyInformation.Name) { }
            column(STRSUBSTNO_Text003_AsOfDate_; StrSubstNo(Text003, AsOfDate)) { }
            column(Item_TABLECAPTION__________ItemFilter; Item.TableCaption() + ': ' + ItemFilter) { }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl) { }
            column(ItemFilter; ItemFilter) { }
            column(UnitCost; UnitCost) { }
            column(Total_Inventory_ValueCaption; Total_Inventory_ValueCaptionLbl) { }
            column(Qty__in_Pallet; "Qty. in Pallet") { }
            trigger OnAfterGetRecord()
            begin
                Clear(Descriptions);
                AdjustItemLedgEntryToAsOfDate("Item Ledger Entry");
                Item.Reset();
                Item.SetRange("No.", "Item No.");
                if Item.FindFirst() then begin
                    Descriptions := Item.Description;
                    CostingMethod := Item."Costing Method";
                end;
                if (ActualCost <> 0) And (RemainiQty <> 0) then begin
                    UnitCost := ActualCost / RemainiQty;
                end;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Posting Date", 0D, AsOfDate);
            end;
        }
    }
    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AsOfDate; AsOfDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'As Of Date';
                        ToolTip = 'Specifies the valuation date.';
                        ShowMandatory = true;
                    }
                }
            }
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformation.get();
        ItemFilter := Item.GetFilters();
    end;

    var
        AsOfDate: Date;
        Currency: Record Currency;
        RemainiQty: Decimal;
        ActualCost: Decimal;
        Item: Record Item;
        Descriptions: Text[100];
        CostingMethod: Enum "Costing Method";
        Inventory_ValuationCaptionLbl: Label 'Inventory Valuation';
        CompanyInformation: Record "Company Information";
        Text003: Label 'Quantities and Values As Of %1';
        ItemFilter: Text;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        UnitCost: Decimal;
        Total_Inventory_ValueCaptionLbl: Label 'Total Inventory Value';
        PalletQty: Decimal;
        ItemLedEntry: Record "Item Ledger Entry";

    local procedure AdjustItemLedgEntryToAsOfDate(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemApplnEntry: Record "Item Application Entry";
        ValueEntry: Record "Value Entry";
        ItemLedgEntry2: Record "Item Ledger Entry";
    begin
#pragma warning disable AL0606
        with ItemLedgEntry do begin
#pragma warning restore AL0606
            RemainiQty := Quantity;
            if Positive then begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey(
                "Inbound Item Entry No.", "Item Ledger Entry No.", "Outbound Item Entry No.", "Cost Application");
                ItemApplnEntry.SetRange("Inbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Posting Date", 0D, AsOfDate);
                ItemApplnEntry.SetFilter("Outbound Item Entry No.", '<>%1', 0);
                ItemApplnEntry.SetFilter("Item Ledger Entry No.", '<>%1', "Entry No.");
                ItemApplnEntry.CalcSums(Quantity);
                RemainiQty += ItemApplnEntry.Quantity;
            end else begin
                ItemApplnEntry.Reset();
                ItemApplnEntry.SetCurrentKey(
                  "Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application", "Transferred-from Entry No.");
                ItemApplnEntry.SetRange("Item Ledger Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Outbound Item Entry No.", "Entry No.");
                ItemApplnEntry.SetRange("Posting Date", 0D, AsOfDate);
                if ItemApplnEntry.Find('-') then
                    repeat
                        if ItemLedgEntry2.Get(ItemApplnEntry."Inbound Item Entry No.") and
                           (ItemLedgEntry2."Posting Date" <= AsOfDate)
                        then
                            RemainiQty := RemainiQty - ItemApplnEntry.Quantity;
                    until ItemApplnEntry.Next() = 0;
            end;
            ValueEntry.Reset();
            ValueEntry.SetRange("Item Ledger Entry No.", "Entry No.");
            ValueEntry.SetRange("Posting Date", 0D, AsOfDate);
            ValueEntry.CalcSums(
              "Cost Amount (Expected)", "Cost Amount (Actual)", "Cost Amount (Expected) (ACY)", "Cost Amount (Actual) (ACY)");
            ActualCost := Round(ValueEntry."Cost Amount (Actual)" + ValueEntry."Cost Amount (Expected)");
            "Cost Amount (Actual) (ACY)" :=
              Round(
                ValueEntry."Cost Amount (Actual) (ACY)" + ValueEntry."Cost Amount (Expected) (ACY)", Currency."Amount Rounding Precision");
        end;
    end;
}