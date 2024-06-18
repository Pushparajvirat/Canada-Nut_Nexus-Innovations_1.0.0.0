#pragma warning disable N0301
page 50117 "Item Availability"
#pragma warning restore N0301
{
    ApplicationArea = All;
    Caption = 'Item Availability';
    PageType = List;
    SourceTable = Item;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the total quantity of the item that is currently in inventory at all locations.';
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
                }
                field("Qty. in Transit"; Rec."Qty. in Transit")
                {
                    ToolTip = 'Specifies the value of the Qty. in Transit field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(FilterByAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Filter by Type';
                Image = EditFilter;
                ToolTip = 'Find items that match specific Type. To make sure you include recent changes made by other users, clear the filter and then reset it.';

                trigger OnAction()
                var
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                    RunOnTempRec: Boolean;
                    SearchString: Text;
                begin
                    FilterPageID := PAGE::"Filter Items by Attribute";
                    if ClientTypeManagement.GetCurrentClientType() = CLIENTTYPE::Phone then
                        FilterPageID := PAGE::"Filter Items by Att. Phone";

                    CloseAction := PAGE.RunModal(FilterPageID, TempFilterItemAttributesBuffer);
                    if (ClientTypeManagement.GetCurrentClientType() <> CLIENTTYPE::Phone) and (CloseAction <> ACTION::LookupOK) then
                        exit;

                    if TempFilterItemAttributesBuffer.IsEmpty() then begin
                        ClearAttributesFilter();
                        exit;
                    end;
                    TempItemFilteredFromAttributes.Reset();
                    TempItemFilteredFromAttributes.DeleteAll();
                    ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
                    FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery() - 100 then begin
                        Rec.FilterGroup(0);
                        Rec.MarkedOnly(false);
                        Rec.SetFilter("No.", FilterText);
                        Rec.FilterGroup(-1);
                        SearchString := '>0';
                        Rec.SetFilter(Inventory, SearchString);
                        Rec.SetFilter("Qty. on Purch. Order", SearchString);
                        Rec.SetFilter("Qty. in Transit", SearchString);
                    end else begin
                        RunOnTempRec := true;
                        Rec.ClearMarks();
                        Rec.Reset();
                    end;
                end;
            }
            action(ClearAttributes)
            {
                AccessByPermission = TableData "Item Attribute" = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Clear Type Filter';
                Image = RemoveFilterLines;
                ToolTip = 'Remove the filter for specific item Type.';

                trigger OnAction()
                begin
                    ClearAttributesFilter();
                    TempItemFilteredFromAttributes.Reset();
                    TempItemFilteredFromAttributes.DeleteAll();
                    RunOnTempRec := false;
                    RestoreTempItemFilteredFromAttributes();
                end;
            }
        }

    }
    var
        ClientTypeManagement: Codeunit "Client Type Management";
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        TempItemFilteredFromAttributes: Record Item temporary;
        TempItemFilteredFromPickItem: Record Item temporary;
        RunOnPickItem: Boolean;
        RunOnTempRec: Boolean;



    local procedure ClearAttributesFilter()
    begin
        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        TempFilterItemAttributesBuffer.Reset();
        TempFilterItemAttributesBuffer.DeleteAll();
        Rec.FilterGroup(0);
        Rec.SetRange("No.");
    end;

    local procedure RestoreTempItemFilteredFromAttributes()
    begin
        if not RunOnPickItem then
            exit;

        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        RunOnTempRec := true;

        if TempItemFilteredFromPickItem.FindSet() then
            repeat
                TempItemFilteredFromAttributes := TempItemFilteredFromPickItem;
                TempItemFilteredFromAttributes.Insert();
            until TempItemFilteredFromPickItem.Next() = 0;
    end;

    procedure GetSelectionFilter(): Text
    var
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Item);
        exit(SelectionFilterManagement.GetSelectionFilterForItem(Item));
    end;
}
