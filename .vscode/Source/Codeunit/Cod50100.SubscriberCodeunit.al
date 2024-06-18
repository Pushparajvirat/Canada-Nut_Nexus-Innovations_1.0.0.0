codeunit 50100 "Subscriber Codeunit"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnInsertConsumptionItemJnlLineOnBeforeValidateQuantity', '', false, false)]
    local procedure OnInsertConsumptionItemJnlLineOnBeforeValidateQuantity(var ItemJnlLine: Record "Item Journal Line"; ProdOrderComp: Record "Prod. Order Component"; NeededQty: Decimal; var IsHandled: Boolean)
    begin
        ItemJnlLine.Validate("Estimated Qty", NeededQty);
        IsHandled := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnValidateQuantityOnBeforeGetUnitAmount', '', false, false)]
    local procedure OnValidateQuantityOnBeforeGetUnitAmount(var ItemJournalLine: Record "Item Journal Line"; xItemJournalLine: Record "Item Journal Line"; CallingFieldNo: Integer)
    begin
        ItemJournalLine.Validate(Variance, (ItemJournalLine.Quantity - ItemJournalLine."Estimated Qty"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnBeforeCalcQuantityOnOrders', '', false, false)]
    local procedure OnBeforeCalcQuantityOnOrders(var PurchBlanketOrderLine: Record "Purchase Line"; var QuantityOnOrders: Decimal; var IsHandled: Boolean)
    var
        PurchLine: Record "Purchase Line";
    begin
        PurchLine.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
        PurchLine.SetRange("Blanket Order No.", PurchBlanketOrderLine."Document No.");
        PurchLine.SetRange("Blanket Order Line No.", PurchBlanketOrderLine."Line No.");
        QuantityOnOrders := 0;
        if PurchLine.FindSet() then
            repeat
                if (PurchLine."Document Type" = PurchLine."Document Type"::"Return Order") or
                   ((PurchLine."Document Type" = PurchLine."Document Type"::"Credit Memo") and
                    (PurchLine."Return Shipment No." = ''))
                then
                    QuantityOnOrders := QuantityOnOrders - PurchLine."Outstanding Quantity"
                else
                    if (PurchLine."Document Type" = PurchLine."Document Type"::Order) or
                       ((PurchLine."Document Type" = PurchLine."Document Type"::Invoice) and
                        (PurchLine."Receipt No." = ''))
                    then
                        QuantityOnOrders := QuantityOnOrders + PurchLine."Outstanding Quantity";
                if QuantityOnOrders <> 0 then begin
                    PurchBlanketOrderLine.Validate("Order Qty.", QuantityOnOrders);
                    PurchBlanketOrderLine.Validate("Balance Qty.", (PurchBlanketOrderLine.Quantity - QuantityOnOrders));
                    PurchBlanketOrderLine.Modify();
                end;
            until PurchLine.Next() = 0
        else begin
            PurchBlanketOrderLine.Validate("Order Qty.", PurchBlanketOrderLine."Qty. to Receive");
            PurchBlanketOrderLine.Validate("Balance Qty.", (PurchBlanketOrderLine.Quantity - PurchBlanketOrderLine."Qty. to Receive"));
            PurchBlanketOrderLine.Modify();
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnRunOnBeforeCheckModifyPurchBlanketOrderLine', '', false, false)]
    local procedure OnRunOnBeforeCheckModifyPurchBlanketOrderLine(var PurchOrderLine: Record "Purchase Line"; var PurchBlanketOrderLine: Record "Purchase Line"; var PurchLine: Record "Purchase Line")
    var
        PurchaseLine2: Record "Purchase Line";
        Item: Record Item;
    begin
        PurchaseLine2.Reset();
        PurchaseLine2.SetRange("Document No.", PurchOrderLine."Document No.");
        if PurchaseLine2.FindLast() then begin
            PurchOrderLine."Entry No." := PurchaseLine2."Entry No." + 1;
        end else begin
            PurchOrderLine."Entry No." := 1;
        end;
        if (PurchOrderLine.Type = PurchOrderLine.Type::Item) And (PurchOrderLine."Document Type" = PurchOrderLine."Document Type"::Order) then begin
            Item.Reset();
            Item.SetRange("No.", PurchOrderLine."No.");
            if Item.FindFirst() then
                if Item."Item Tracking Code" <> '' then begin
                    PurchOrderLine."Lot No." := (PurchOrderLine."Document No.") + '-' + Format(PurchOrderLine."Entry No.");
                    PurchOrderLine.Modify();
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blnkt Purch Ord. to Ord. (Y/N)", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        PurchaHeader: Record "Purchase Header";
    begin
        PurchaHeader.Reset();
        PurchaHeader.SetRange("No.", PurchaseHeader."No.");
        if PurchaHeader.FindFirst() then begin
            if PurchaseHeader."Advance %" <> 0 then begin
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                if PurchaseLine.FindSet() then
                    repeat
                        if PurchaseLine."Advance Voucher No." <> '' then
                            if PurchaseLine."Rec Amt Voucher No." <> '' then
                                IsHandled := false
                            else begin
                                Error('Advance Amount Still Needs to Paid and Applied');
                                IsHandled := true;
                            end
                        else begin
                            Error('Advance Invoice needs to be Posted');
                            IsHandled := true;
                        end;
                    until PurchaseLine.Next() = 0;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateQuantity', '', false, false)]
    local procedure OnBeforeValidateQuantity(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        ItemUOM: Record "Item Unit of Measure";
        Item: Record Item;
        WarehouseSetup: Record "Warehouse Setup";
    begin
        Item.Reset();
        Item.SetRange("No.", PurchaseLine."No.");
        if Item.FindFirst() then begin
            WarehouseSetup.Get();
            If PurchaseLine."Unit of Measure Code" = 'CS' then begin
                PurchaseLine."Net Weight" := PurchaseLine.Quantity * Item."Net Weight";
            end else
                PurchaseLine."Net Weight" := PurchaseLine.Quantity;
            if Item."LB Conversion" then begin
                ItemUOM.Reset();
                ItemUOM.SetRange("Item No.", PurchaseLine."No.");
                ItemUOM.SetRange(Code, 'LB');
                if ItemUOM.FindFirst() then begin
                    PurchaseLine.Validate("Weight in LBS", (PurchaseLine.Quantity * ItemUOM."Qty. per Unit of Measure"));
                end;
                ItemUOM.Reset();
                ItemUOM.SetRange("Item No.", PurchaseLine."No.");
                ItemUOM.SetRange(Code, 'KG');
                if ItemUOM.FindFirst() then begin
                    PurchaseLine.Validate("Weight in KG", (PurchaseLine.Quantity * ItemUOM."Qty. per Unit of Measure"));
                end;
            end;
        end;
        If PurchaseLine."Balance Qty." = 0 then
            PurchaseLine."Balance Qty." := PurchaseLine.Quantity
        else
            PurchaseLine."Balance Qty." := PurchaseLine.Quantity - PurchaseLine."Order Qty."
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateQuantity', '', false, false)]
    local procedure OnBeforeValidateQuantitySales(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    var
        ItemUOM: Record "Item Unit of Measure";
        Item: Record Item;
    begin
        Item.Reset();
        Item.SetRange("No.", SalesLine."No.");
        if Item.FindFirst() then begin
            if Item."LB Conversion" then begin
                ItemUOM.Reset();
                ItemUOM.SetRange("Item No.", SalesLine."No.");
                ItemUOM.SetRange(Code, 'LB');
                if ItemUOM.FindFirst() then begin
                    SalesLine.Validate("Weight in LBS", (SalesLine.Quantity * ItemUOM."Qty. per Unit of Measure"));
                end;
                ItemUOM.Reset();
                ItemUOM.SetRange("Item No.", SalesLine."No.");
                ItemUOM.SetRange(Code, 'KG');
                if ItemUOM.FindFirst() then begin
                    SalesLine.Validate("Weight in KG", (SalesLine.Quantity * ItemUOM."Qty. per Unit of Measure"));
                end;
            end;
        end;
        If SalesLine."Balance Qty." = 0 then
            SalesLine."Balance Qty." := SalesLine.Quantity
        else
            SalesLine."Balance Qty." := SalesLine.Quantity - SalesLine."Order Qty."
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFieldsForNo', '', false, false)]
    local procedure OnAfterAssignFieldsForNo(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    begin
        SalesLine."ETD Date" := SalesHeader."ETD Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnBeforeCheckBlanketOrderLineQuantity', '', false, false)]
    local procedure OnBeforeCheckBlanketOrderLineQuantity(var BlanketOrderSalesLine: Record "Sales Line"; QuantityOnOrders: Decimal; var IsHandled: Boolean)
    var
        Salesline: Record "Sales Line";
    begin
        Salesline.SetCurrentKey("Document Type", "Blanket Order No.", "Blanket Order Line No.");
        Salesline.SetRange("Blanket Order No.", BlanketOrderSalesLine."Document No.");
        Salesline.SetRange("Blanket Order Line No.", BlanketOrderSalesLine."Line No.");
        QuantityOnOrders := 0;
        if Salesline.FindSet() then
            repeat
                if (Salesline."Document Type" = Salesline."Document Type"::"Return Order") or
                   ((Salesline."Document Type" = Salesline."Document Type"::"Credit Memo") and
                    (Salesline."Return Receipt No." = ''))
                then
                    QuantityOnOrders := QuantityOnOrders - Salesline."Outstanding Quantity"
                else
                    if (Salesline."Document Type" = Salesline."Document Type"::Order) or
                       ((Salesline."Document Type" = Salesline."Document Type"::Invoice) and
                        (Salesline."Shipment No." = ''))
                    then
                        QuantityOnOrders := QuantityOnOrders + Salesline."Outstanding Quantity";
                if QuantityOnOrders <> 0 then begin
                    BlanketOrderSalesLine.Validate("Order Qty.", QuantityOnOrders);
                    BlanketOrderSalesLine.Validate("Balance Qty.", (BlanketOrderSalesLine.Quantity - QuantityOnOrders));
                    BlanketOrderSalesLine.Modify();
                end;
            until Salesline.Next() = 0
        else begin
            BlanketOrderSalesLine.Validate("Order Qty.", BlanketOrderSalesLine."Qty. to Ship");
            BlanketOrderSalesLine.Validate("Balance Qty.", (BlanketOrderSalesLine.Quantity - BlanketOrderSalesLine."Qty. to Ship"));
            BlanketOrderSalesLine.Modify();
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnBeforePurchOrderHeaderModify', '', false, false)]
    local procedure OnBeforePurchOrderHeaderModify(var PurchOrderHeader: Record "Purchase Header"; BlanketOrderPurchHeader: Record "Purchase Header")
    begin
        PurchOrderHeader.Validate("Prepayment %", BlanketOrderPurchHeader."Advance %");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Purch. Order to Order", 'OnAfterPurchOrderLineInsert', '', false, false)]
    local procedure OnAfterPurchOrderLineInsert(var PurchaseLine: Record "Purchase Line"; var BlanketOrderPurchLine: Record "Purchase Line")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.Reset();
        PurchaseHeader.SetRange("No.", PurchaseLine."Document No.");
        if PurchaseHeader.FindFirst() then begin
            if PurchaseHeader."Prepayment %" <> 0 then begin
                PurchaseLine.Validate("Prepayment %", PurchaseHeader."Prepayment %");
                PurchaseLine."Prepmt. Amt. Inv." := PurchaseLine."Prepmt. Line Amount";
                PurchaseLine."Prepmt. Amt. Incl. VAT" := PurchaseLine."Prepmt. Line Amount";
                PurchaseLine."Prepayment Amount" := PurchaseLine."Prepmt. Line Amount";
                PurchaseLine."Prepmt Amt to Deduct" := PurchaseLine."Prepmt. Line Amount";
                PurchaseLine."Prepmt. Amount Inv. Incl. VAT" := PurchaseLine."Prepmt. Line Amount";
                PurchaseLine."Prepmt. Amount Inv. (LCY)" := PurchaseLine."Prepmt. Line Amount";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Blanket Sales Order to Order", 'OnRunOnBeforeResetQuantityFields', '', false, false)]
    local procedure OnRunOnBeforeResetQuantityFields(var BlanketOrderSalesLine: Record "Sales Line"; var SalesOrderLine: Record "Sales Line")
    begin
        SalesOrderLine."Minimum Order Qty." := BlanketOrderSalesLine."Minimum Order Qty.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateNoPurchaseLine', '', false, false)]
    local procedure OnAfterValidateNoPurchaseLine(var PurchaseLine: Record "Purchase Line"; var xPurchaseLine: Record "Purchase Line"; var TempPurchaseLine: Record "Purchase Line" temporary; PurchaseHeader: Record "Purchase Header")
    var
        Item: Record Item;
        PurchaseLine2: Record "Purchase Line";
    begin
        PurchaseLine2.Reset();
        PurchaseLine2.SetRange("Document No.", PurchaseLine."Document No.");
        if PurchaseLine2.FindLast() then begin
            PurchaseLine."Entry No." := PurchaseLine2."Entry No." + 1;
        end else begin
            PurchaseLine."Entry No." := 1;
        end;
        if (PurchaseLine.Type = PurchaseLine.Type::Item) And (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) then begin
            Item.Reset();
            Item.SetRange("No.", PurchaseLine."No.");
            if Item.FindFirst() then
                if Item."Item Tracking Code" <> '' then begin
                    PurchaseLine."Lot No." := (PurchaseLine."Document No.") + '-' + Format(PurchaseLine."Entry No.");
                end;
        end;
        PurchaseLine."ETD Date" := PurchaseHeader.ETD;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Charge Assignment (Purch)", 'OnAfterUpdateQty', '', false, false)]
    local procedure OnAfterUpdateQty(var ItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)"; var QtyToReceiveBase: Decimal; var QtyReceivedBase: Decimal; var QtyToShipBase: Decimal; var QtyShippedBase: Decimal; var GrossWeight: Decimal; var UnitVolume: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        case ItemChargeAssignmentPurch."Applies-to Doc. Type" of
            "Purchase Applies-to Document Type"::"Return Receipt":
                begin
                    PurchaseLine.Get(ItemChargeAssignmentPurch."Applies-to Doc. No.", ItemChargeAssignmentPurch."Applies-to Doc. Line No.");
                    QtyToReceiveBase := 0;
                    QtyReceivedBase := PurchaseLine."Quantity (Base)";
                    QtyToShipBase := 0;
                    QtyShippedBase := 0;
                    GrossWeight := PurchaseLine."Gross Weight";
                    UnitVolume := PurchaseLine."Unit Volume";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(var PurchaseLine: Record "Purchase Line"; Item: Record Item; CallingFieldNo: Integer)
    begin
        PurchaseLine."Indirect Cost Amount" := Item."Indirect Cost Amount";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateAmountsDone', '', false, false)]

    local procedure OnAfterUpdateAmountsDone(var PurchLine: Record "Purchase Line"; var xPurchLine: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        if PurchLine."Line Amount" <> 0 then
            PurchLine.Validate("Indirect Cost %", ((PurchLine."Indirect Cost Amount" * PurchLine.Quantity) / PurchLine."Line Amount") * 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeletePurchaseLines', '', false, false)]
    local procedure OnBeforeDeletePurchaseLines(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLineBlanket: Record "Purchase Line";
        ReservMgt: Codeunit "Reservation Management";
    begin
        if PurchaseLine.FindSet() then begin
            ReservMgt.DeleteDocumentReservation(
                DATABASE::"Purchase Line", PurchaseHeader."Document Type".AsInteger(), PurchaseHeader."No.", PurchaseHeader.GetHideValidationDialog());
            repeat
                PurchaseLine.SuspendStatusCheck(true);
                if PurchaseLine."Blanket Order No." <> '' then begin
                    PurchaseLineBlanket.Reset();
                    PurchaseLineBlanket.SetRange("Document No.", PurchaseLine."Blanket Order No.");
                    PurchaseLineBlanket.SetRange("Line No.", PurchaseLine."Blanket Order Line No.");
                    if PurchaseLineBlanket.FindSet() then
                        repeat
                            PurchaseLineBlanket."Order Qty." := PurchaseLineBlanket."Order Qty." - PurchaseLine."Outstanding Quantity";
                            PurchaseLineBlanket."Balance Qty." := PurchaseLineBlanket.Quantity - PurchaseLineBlanket."Order Qty.";
                            PurchaseLineBlanket.Modify();
                        until PurchaseLineBlanket.Next() = 0;
                end;
                PurchaseLine.Delete(true);
            until PurchaseLine.Next() = 0;
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteSalesLines', '', false, false)]
    local procedure OnBeforeDeleteSalesLines(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var SalesHeader: Record "Sales Header");
    Var
        PurchaseLineBlanket: Record "Purchase Line";
        ReservMgt: Codeunit "Reservation Management";
    begin
        if SalesLine.FindSet() then begin
            ReservMgt.DeleteDocumentReservation(
                DATABASE::"Purchase Line", SalesHeader."Document Type".AsInteger(), SalesHeader."No.", SalesHeader.GetHideValidationDialog());
            repeat
                SalesLine.SuspendStatusCheck(true);
                if SalesLine."Blanket Order No." <> '' then begin
                    PurchaseLineBlanket.Reset();
                    PurchaseLineBlanket.SetRange("Document No.", SalesLine."Blanket Order No.");
                    PurchaseLineBlanket.SetRange("Line No.", SalesLine."Blanket Order Line No.");
                    if PurchaseLineBlanket.FindSet() then
                        repeat
                            PurchaseLineBlanket."Order Qty." := PurchaseLineBlanket."Order Qty." - SalesLine."Outstanding Quantity";
                            PurchaseLineBlanket."Balance Qty." := PurchaseLineBlanket.Quantity - PurchaseLineBlanket."Order Qty.";
                            PurchaseLineBlanket.Modify();
                        until PurchaseLineBlanket.Next() = 0;
                end;
                SalesLine.Delete(true);
            until SalesLine.Next() = 0;
        end;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnPurchLine2ReceiptLineOnAfterSetQtysOnRcptLine', '', false, false)]
    local procedure OnPurchLine2ReceiptLineOnAfterSetQtysOnRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; PurchaseLine: Record "Purchase Line")
    var
        purchseheader: Record "Purchase Header";
        Item: Record Item;
        Location: Record Location;
        StockeepingUnit: Record "Stockkeeping Unit";
    begin
        WarehouseReceiptLine."Net Weight" := PurchaseLine."Net Weight";
        Item.Reset();
        Item.SetRange("No.", PurchaseLine."No.");
        If Item.FindFirst() then begin
            Item.CalcFields("Stockkeeping Unit Exists");
            if Item."Stockkeeping Unit Exists" then begin
                StockeepingUnit.Reset();
                StockeepingUnit.SetRange("Item No.", Item."No.");
                StockeepingUnit.SetRange("Location Code", WarehouseReceiptLine."Location Code");
                StockeepingUnit.SetRange("Variant Code", WarehouseReceiptLine."Variant Code");
                if StockeepingUnit.FindFirst() then begin
                    StockeepingUnit.TestField("Qty. By Pallet");
                    WarehouseReceiptLine."Qty. in Pallet" := (WarehouseReceiptLine.Quantity / StockeepingUnit."Qty. By Pallet")
                end;
            end else begin
                Item.TestField("Qty. By Pallet");
                WarehouseReceiptLine."Qty. in Pallet" := (WarehouseReceiptLine.Quantity / Item."Qty. By Pallet")
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterFindWhseRcptLineForPurchLine', '', false, false)]
    local procedure OnAfterFindWhseRcptLineForPurchLine(var WhseRcptLine: Record "Warehouse Receipt Line"; var PurchaseLine: Record "Purchase Line");
    begin
        PurchaseLine."Qty. By Pallet" := WhseRcptLine."Qty. in Pallet";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line");
    begin
        ItemJnlLine."Qty. in Pallet" := PurchLine."Qty. By Pallet";
        ItemJnlLine."Price Per SUOM" := PurchLine."Price Per Kg";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        NewItemLedgEntry."Price Per SUOM" := ItemJournalLine."Price Per SUOM";
        NewItemLedgEntry."Qty. in Pallet" := ItemJournalLine."Qty. in Pallet";
        NewItemLedgEntry."Country Of Origin" := ItemJournalLine."Country Of Origin";
        NewItemLedgEntry."Status Code" := ItemJournalLine."Status Code";
        NewItemLedgEntry."Production Date" := ItemJournalLine."Production Date";
        NewItemLedgEntry."Pallet No." := ItemJournalLine."Pallet No.";
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase then
            NewItemLedgEntry."Net Weight" := ItemJournalLine."Net Weight";
        if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Sale then
            NewItemLedgEntry."Net Weight" := -(ItemJournalLine."Net Weight");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnValidateQuantityOnBeforeTransLineVerifyChange', '', false, false)]
    local procedure OnValidateQuantityOnBeforeTransLineVerifyChange(var TransferLine: Record "Transfer Line"; xTransferLine: Record "Transfer Line"; var IsHandled: Boolean)
    VAr
        Item: Record Item;
        Location: Record Location;
        StockeepingUnit: Record "Stockkeeping Unit";
        TransferHeader: Record "Transfer Header";
    begin
        Item.Reset();
        Item.SetRange("No.", TransferLine."Item No.");
        If Item.FindFirst() then begin
            Item.CalcFields("Stockkeeping Unit Exists");
            if Item."Stockkeeping Unit Exists" then begin
                TransferHeader.Get(TransferLine."Document No.");
                StockeepingUnit.Reset();
                StockeepingUnit.SetRange("Item No.", Item."No.");
                StockeepingUnit.SetRange("Location Code", TransferHeader."Transfer-from Code");
                StockeepingUnit.SetRange("Variant Code", TransferLine."Variant Code");
                if StockeepingUnit.FindFirst() then
                    TransferLine."Qty. in Pallet" := (TransferLine.Quantity / StockeepingUnit."Qty. By Pallet")
                else
                    TransferLine."Qty. in Pallet" := (TransferLine.Quantity / Item."Qty. By Pallet");
            end else
                TransferLine."Qty. in Pallet" := (TransferLine.Quantity / Item."Qty. By Pallet");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnFromTransLine2ShptLineOnAfterInitNewLine', '', false, false)]
    local procedure OnFromTransLine2ShptLineOnAfterInitNewLine(var WhseShptLine: Record "Warehouse Shipment Line"; WhseShptHeader: Record "Warehouse Shipment Header"; TransferLine: Record "Transfer Line")
    begin
        WhseShptLine."Qty. in Pallet" := TransferLine."Qty. in Pallet";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Create Source Document", 'OnTransLine2ReceiptLineOnAfterInitNewLine', '', false, false)]
    local procedure OnTransLine2ReceiptLineOnAfterInitNewLine(var WhseReceiptLine: Record "Warehouse Receipt Line"; WhseReceiptHeader: Record "Warehouse Receipt Header"; TransferLine: Record "Transfer Line")
    begin
        WhseReceiptLine."Qty. in Pallet" := TransferLine."Qty. in Pallet";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line")
    begin
        if ItemJournalLine.Quantity > 0 then
            ItemJournalLine."Qty. in Pallet" := (TransferLine."Qty. in Pallet")
        else
            ItemJournalLine."Qty. in Pallet" := -(TransferLine."Qty. in Pallet");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header")
    begin
        if ItemJournalLine.Quantity > 0 then
            ItemJournalLine."Qty. in Pallet" := TransLine."Qty. in Pallet"
        else
            ItemJournalLine."Qty. in Pallet" := -(TransLine."Qty. in Pallet");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeShowReservation', '', false, false)]
    local procedure OnBeforeShowReservation(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    var
        Reservation: Page Reservation;
    begin
        SalesLine.TestField(SalesLine.Type, SalesLine.Type::Item);
        SalesLine.TestField(SalesLine."No.");
        SalesLine.TestField(SalesLine.Reserve);
        Clear(Reservation);
        Reservation.SetReservSource(SalesLine);
        Reservation.Gettable(SalesLine);
        Reservation.RunModal();
        SalesLine.UpdatePlanned();
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer; FloatingFactor: Decimal)
    begin
        TempItemJournalLine."Country Of Origin" := TempTrackingSpecification."Country Of Origin";
        TempItemJournalLine."Status Code" := TempTrackingSpecification."Status Code";
        TempItemJournalLine."Net Weight" := TempTrackingSpecification."Net Weight";
        TempItemJournalLine."Production Date" := TempTrackingSpecification."Production Date";
        TempItemJournalLine."Pallet No." := TempTrackingSpecification."Pallet No.";
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAssistEditTrackingNoOnAfterAssignTrackingToSpec', '', false, false)]
    // local procedure OnAssistEditTrackingNoOnAfterAssignTrackingToSpec(var TempTrackingSpecification: Record "Tracking Specification" temporary; TempGlobalEntrySummary: Record "Entry Summary")
    // begin
    //     TempTrackingSpecification."Country Of Origin" := TempGlobalEntrySummary."Country Of Origin";
    // end;


    [EventSubscriber(ObjectType::Table, Database::"Entry Summary", 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromReservEntry(var ToEntrySummary: Record "Entry Summary"; FromReservEntry: Record "Reservation Entry")
    begin
        ToEntrySummary."Country Of Origin" := FromReservEntry."Country Of Origin";
        ToEntrySummary."Status Code" := FromReservEntry."Status Code";
        ToEntrySummary."Net Weight" := FromReservEntry."Net Weight";
        ToEntrySummary."Production Date" := FromReservEntry."Production Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterInitFromPurchLine', '', false, false)]
    local procedure OnAfterInitFromPurchLine(var TrackingSpecification: Record "Tracking Specification"; PurchaseLine: Record "Purchase Line")
    begin
        TrackingSpecification."Country Of Origin" := PurchaseLine."Country of Origin";
        TrackingSpecification."Status Code" := PurchaseLine."Status Code";
        TrackingSpecification."Net Weight" := PurchaseLine."Net Weight";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure ItemTrackingLinesOnAfterMoveFields(var ReservEntry: Record "Reservation Entry"; var TrkgSpec: Record "Tracking Specification")
    begin
        ReservEntry."Net Weight" := TrkgSpec."Net Weight";
        ReservEntry."Country Of Origin" := TrkgSpec."Country Of Origin";
        ReservEntry."Status Code" := TrkgSpec."Status Code";
        ReservEntry."Production Date" := TrkgSpec."Production Date";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure ItemTrackingLinesOnAfterCopyTrackingSpec(var DestTrkgSpec: Record "Tracking Specification"; var SourceTrackingSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec."Net Weight" := SourceTrackingSpec."Net Weight";
        DestTrkgSpec."Country Of Origin" := SourceTrackingSpec."Country Of Origin";
        DestTrkgSpec."Status Code" := SourceTrackingSpec."Status Code";
        DestTrkgSpec."Production Date" := SourceTrackingSpec."Production Date";
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnAfterCreateReservEntry', '', false, false)]
    local procedure ItemTrackingLinesOnRegisterChangeOnAfterCreateReservEntry(var ReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry."Net Weight" := OldTrackingSpecification."Net Weight";
        ReservEntry."Country Of Origin" := OldTrackingSpecification."Country Of Origin";
        ReservEntry."Status Code" := OldTrackingSpecification."Status Code";
        ReservEntry."Production Date" := OldTrackingSpecification."Production Date";
        ReservEntry.Modify();
        UpdateSalesLines(ReservEntry);
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertReservEntryForSalesLine', '', false, false)]
    local procedure OnBeforeInsertReservEntryForSalesLine(var ReservEntry: Record "Reservation Entry"; SalesLine: Record "Sales Line"; ItemLedgerEntry: Record "Item Ledger Entry");
    var
    begin
        ReservEntry."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
        ReservEntry."Status Code" := ItemLedgerEntry."Status Code";
        ReservEntry."Net Weight" := ItemLedgerEntry."Net Weight";
        ReservEntry."Production Date" := ItemLedgerEntry."Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertReservEntryForPurchLine', '', false, false)]
    local procedure OnBeforeInsertReservEntryForPurchaseLine(var ReservEntry: Record "Reservation Entry"; PurchLine: Record "Purchase Line"; ItemLedgerEntry: Record "Item Ledger Entry");
    var
        ITemRec: Record Item;
    begin
        ReservEntry."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
        ReservEntry."Status Code" := ItemLedgerEntry."Status Code";
        ReservEntry."Net Weight" := ItemLedgerEntry."Net Weight";
        ReservEntry."Production Date" := ItemLedgerEntry."Production Date";
    end;

    local procedure UpdateSalesLines(ReservationEntry: Record "Reservation Entry")
    var
        SalesLine: Record "Sales Line";
        CatchWeight: Decimal;
        ReserEntry: Record "Reservation Entry";
    begin
        if ReservationEntry."Source Type" = 37 then Begin
            ReserEntry.SetRange("Source Type", ReservationEntry."Source Type");
            ReserEntry.SetRange("Source Subtype", ReservationEntry."Source Subtype");
            ReserEntry.SetRange("Source ID", ReservationEntry."Source ID");
            ReserEntry.SetRange("Source Ref. No.", ReservationEntry."Source Ref. No.");
            if ReserEntry.FindSet() then
                repeat
                    CatchWeight += ReserEntry."Net Weight";
                until ReserEntry.Next() = 0;
            SalesLine.SetRange("Document No.", ReservationEntry."Source ID");
            SalesLine.SetRange("Line No.", ReservationEntry."Source Ref. No.");
            if SalesLine.FindFirst() then begin
                SalesLine."Net Weight" := CatchWeight;
                SalesLine.Modify();
            end;
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnSetupSplitJnlLineOnBeforeCheckUseExpirationDates', '', false, false)]
    local procedure OnSetupSplitJnlLineOnBeforeCheckUseExpirationDates(var ItemJnlLine2: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification" temporary; Item: Record Item; var CalcExpirationDate: Date)
    var
        GlobalTrackingCode: Record "Item Tracking Code";
    begin
        if GlobalTrackingCode.Get(Item."Item Tracking Code") then
            if GlobalTrackingCode."Strict Country Of Origin" then begin
                if ItemJnlLine2."Entry Type" <> ItemJnlLine2."Entry Type"::Transfer then
                    TempTrackingSpecification.TestField("Country Of Origin");
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Entry Summary", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromSpec(var ToEntrySummary: Record "Entry Summary"; TrackingSpecification: Record "Tracking Specification")
    begin
        ToEntrySummary."Country Of Origin" := TrackingSpecification."Country Of Origin";
        ToEntrySummary."Status Code" := TrackingSpecification."Status Code";
        ToEntrySummary."Net Weight" := TrackingSpecification."Net Weight";
        ToEntrySummary."Production Date" := TrackingSpecification."Production Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure WhseActivityLineCopyTrackingFromSpec(var WarehouseActivityLine: Record "Warehouse Activity Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        WarehouseActivityLine."Pallet No." := TrackingSpecification."Pallet No.";
        WarehouseActivityLine."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterCopyTrackingFromItemLedgEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemLedgEntry(var ReservationEntry: Record "Reservation Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ReservationEntry."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
        ReservationEntry."Status Code" := ItemLedgerEntry."Status Code";
        ReservationEntry."Net Weight" := ItemLedgerEntry."Net Weight";
        ReservationEntry."Production Date" := ItemLedgerEntry."Production Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Entry", 'OnAfterCopyTrackingFromWhseJnlLine', '', false, false)]
    local procedure OnAfterCopyTrackingFromWhseJnlLine(var WarehouseEntry: Record "Warehouse Entry"; WarehouseJournalLine: Record "Warehouse Journal Line")
    begin
        WarehouseEntry."Pallet No." := WarehouseJournalLine."Pallet No.";
        WarehouseEntry."Country Of Origin" := WarehouseJournalLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCopyTrackingFromItemLedgEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromWhseItemLedgEntry(var WhseJnlLine: Record "Warehouse Journal Line"; ItemLedgEntry: Record "Item Ledger Entry")
    begin
        WhseJnlLine."Pallet No." := ItemLedgEntry."Pallet No.";
        WhseJnlLine."Country Of Origin" := ItemLedgEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCopyTrackingFromWhseActivityLine', '', false, false)]
    local procedure OnAfterCopyTrackingFromWhseActivityLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; WarehouseActivityLine: Record "Warehouse Activity Line")
    begin
        WarehouseJournalLine."Pallet No." := WarehouseActivityLine."Pallet No.";
        WarehouseJournalLine."Country Of Origin" := WarehouseActivityLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure OnAfterCopyWhseTrackingFromSpec(var WarehouseActivityLine: Record "Warehouse Activity Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        WarehouseActivityLine."Pallet No." := TrackingSpecification."Pallet No.";
        WarehouseActivityLine."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCopyTrackingFromItemTrackingSetupIfRequired', '', false, false)]
    local procedure WarehouseJournalLineCopyTrackingFromItemTrackingSetupIfRequired(var WhseJnlLine: Record "Warehouse Journal Line"; WhseItemTrackingSetup: Record "Item Tracking Setup")
    begin
        WhseJnlLine."Pallet No." := WhseItemTrackingSetup."Pallet No.";
        WhseJnlLine."Country Of Origin" := WhseItemTrackingSetup."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromItemLedgerEntry', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromItemLedgerEntry(var ItemTrackingSetup: Record "Item Tracking Setup"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ItemTrackingSetup."Pallet No." := ItemLedgerEntry."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromItemJnlLine', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromItemJnlLine(var ItemTrackingSetup: Record "Item Tracking Setup"; ItemJnlLine: Record "Item Journal Line")
    begin
        ItemTrackingSetup."Pallet No." := ItemJnlLine."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := ItemJnlLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromItemTrackingSetup', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromItemTrackingSetup(var ItemTrackingSetup: Record "Item Tracking Setup"; FromItemTrackingSetup: Record "Item Tracking Setup")
    begin
        ItemTrackingSetup."Pallet No." := FromItemTrackingSetup."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := FromItemTrackingSetup."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromReservEntry(var ItemTrackingSetup: Record "Item Tracking Setup"; ReservEntry: Record "Reservation Entry")
    begin
        ItemTrackingSetup."Pallet No." := ReservEntry."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := ReservEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromTrackingSpec(var ItemTrackingSetup: Record "Item Tracking Setup"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemTrackingSetup."Pallet No." := TrackingSpecification."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromWhseActivityLine', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromWhseActivityLine(var ItemTrackingSetup: Record "Item Tracking Setup"; WhseActivityLine: Record "Warehouse Activity Line")
    begin
        ItemTrackingSetup."Pallet No." := WhseActivityLine."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := WhseActivityLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromWhseEntry', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromWhseEntry(var ItemTrackingSetup: Record "Item Tracking Setup"; WhseEntry: Record "Warehouse Entry")
    begin
        ItemTrackingSetup."Pallet No." := WhseEntry."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := WhseEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromWhseItemTrackingLine', '', false, false)]
    local procedure ItemTrackingSetupCopyTrackingFromWhseItemTrackingLine(var ItemTrackingSetup: Record "Item Tracking Setup"; WhseItemTrackingLine: Record "Whse. Item Tracking Line")
    begin
        ItemTrackingSetup."Pallet No." := WhseItemTrackingLine."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := WhseItemTrackingLine."Country Of Origin";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnTransferItemLedgToTempRecOnBeforeInsert', '', false, false)]
    local procedure OnTransferItemLedgToTempRecOnBeforeInsert(var TempGlobalReservEntry: Record "Reservation Entry" temporary; ItemLedgerEntry: Record "Item Ledger Entry"; TrackingSpecification: Record "Tracking Specification"; var IsHandled: Boolean)
    begin
        TempGlobalReservEntry."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
        TempGlobalReservEntry."Status Code" := ItemLedgerEntry."Status Code";
        TempGlobalReservEntry."Net Weight" := ItemLedgerEntry."Net Weight";
        TempGlobalReservEntry."Production Date" := ItemLedgerEntry."Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterTransferExpDateFromSummary', '', false, false)]
    local procedure OnAfterTransferExpDateFromSummary(var TrackingSpecification: Record "Tracking Specification"; var TempEntrySummary: Record "Entry Summary" temporary)
    begin
        TrackingSpecification."Country Of Origin" := TempEntrySummary."Country Of Origin";
        TrackingSpecification."Status Code" := TempEntrySummary."Status Code";
        TrackingSpecification."Net Weight" := TempEntrySummary."Net Weight";
        TrackingSpecification."Production Date" := TempEntrySummary."Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAddSelectedTrackingToDataSetOnAfterInitTrackingSpecification2', '', false, false)]
    local procedure OnAddSelectedTrackingToDataSetOnAfterInitTrackingSpecification2(var TrackingSpecification: Record "Tracking Specification"; TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        TrackingSpecification."Country Of Origin" := TempTrackingSpecification."Country Of Origin";
        TrackingSpecification."Status Code" := TempTrackingSpecification."Status Code";
        TrackingSpecification."Net Weight" := TempTrackingSpecification."Net Weight";
        TrackingSpecification."Production Date" := TempTrackingSpecification."Production Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment', '', false, false)]
    local procedure OnCreateEntrySummary2OnAfterSetDoubleEntryAdjustment(var TempGlobalEntrySummary: Record "Entry Summary"; var TempReservEntry: Record "Reservation Entry")
    begin
        TempGlobalEntrySummary."Country Of Origin" := TempReservEntry."Country Of Origin";
        TempGlobalEntrySummary."Status Code" := TempReservEntry."Status Code";
        TempGlobalEntrySummary."Net Weight" := TempReservEntry."Net Weight";
        TempGlobalEntrySummary."Production Date" := TempReservEntry."Production Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Posted Whse. Receipt Line", 'OnAfterCopyTrackingFromWhseItemEntryRelation', '', false, false)]
    local procedure OnAfterCopyTrackingFromWhseItemEntryRelation(var PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; WhseItemEntryRelation: Record "Whse. Item Entry Relation")
    begin
        PostedWhseReceiptLine."Pallet No." := WhseItemEntryRelation."Pallet No.";
        PostedWhseReceiptLine."Country Of Origin" := WhseItemEntryRelation."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Activity Line", 'OnAfterCopyTrackingFromPostedWhseRcptLine', '', false, false)]
    local procedure OnAfterCopyTrackingFromPostedWhseRcptLine(var WarehouseActivityLine: Record "Warehouse Activity Line"; PostedWhseRcptLine: Record "Posted Whse. Receipt Line")
    begin
        WarehouseActivityLine."Pallet No." := PostedWhseRcptLine."Pallet No.";
        WarehouseActivityLine."Country Of Origin" := PostedWhseRcptLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Whse. Item Entry Relation", 'OnAfterInitFromTrackingSpec', '', false, false)]
    local procedure OnAfterInitFromTrackingSpec(var WhseItemEntryRelation: Record "Whse. Item Entry Relation"; TrackingSpecification: Record "Tracking Specification")
    begin
        WhseItemEntryRelation."Pallet No." := TrackingSpecification."Pallet No.";
        WhseItemEntryRelation."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeInsertWhseItemTrkgLines', '', false, false)]
    local procedure OnBeforeInsertWhseItemTrkgLines(var WhseItemTrkgLine: Record "Whse. Item Tracking Line"; PostedWhseReceiptLine: Record "Posted Whse. Receipt Line"; WhseItemEntryRelation: Record "Whse. Item Entry Relation"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        WhseItemTrkgLine."Pallet No." := ItemLedgerEntry."Pallet No.";
        WhseItemTrkgLine."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var SkipCheckReleaseRestrictions: Boolean; var IsHandled: Boolean; SkipWhseRequestOperations: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        ReservationEntry: Record "Reservation Entry";
    begin
        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then begin
            repeat
                PurchaseLine.TestField("Country of Origin");
                PurchaseLine.TestField("Status Code");
            until PurchaseLine.Next() = 0;
        end;
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source ID", PurchaseHeader."No.");
        if Not ReservationEntry.FindSet() then
            Error('Please Assign Lot No.');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure TrackingSpecificationCopyTrackingFromReservEntry(var TrackingSpecification: Record "Tracking Specification"; ReservEntry: Record "Reservation Entry")
    begin
        TrackingSpecification."Country Of Origin" := ReservEntry."Country Of Origin";
        TrackingSpecification."Pallet No." := ReservEntry."Pallet No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnAfterSetNewTrackingFromItemJnlLine', '', false, false)]
    local procedure OnAfterSetNewTrackingFromItemJnlLine(var InsertReservEntry: Record "Reservation Entry"; ItemJnlLine: Record "Item Journal Line")
    begin
        InsertReservEntry."Pallet No." := ItemJnlLine."Pallet No.";
        InsertReservEntry."Country Of Origin" := ItemJnlLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromTrackingSpec(var TrackingSpecification: Record "Tracking Specification"; FromTrackingSpecification: Record "Tracking Specification")
    begin
        TrackingSpecification."Pallet No." := FromTrackingSpecification."Pallet No.";
        TrackingSpecification."Country Of Origin" := FromTrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterSetTrackingFilterFromItemTrackingSetup', '', false, false)]
    local procedure OnAfterSetTrackingFilterFromItemTrackingSetup(var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup")
    begin
        TrackingSpecification."Pallet No." := ItemTrackingSetup."Pallet No.";
        TrackingSpecification."Country Of Origin" := ItemTrackingSetup."Country Of Origin";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterSetTrackingFilterFromItemLedgEntry', '', false, false)]
    local procedure OnAfterSetTrackingFilterFromItemLedgEntry(var TrackingSpecification: Record "Tracking Specification"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        TrackingSpecification."Pallet No." := ItemLedgerEntry."Pallet No.";
        TrackingSpecification."Country Of Origin" := ItemLedgerEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterCopyNewTrackingFromTrackingSpec', '', false, false)]
    local procedure OnAfterCopyNewTrackingFromTrackingSpec(var TrackingSpecification: Record "Tracking Specification"; FromTrackingSpecification: Record "Tracking Specification")
    begin
        TrackingSpecification."Pallet No." := FromTrackingSpecification."Pallet No.";
        TrackingSpecification."Country Of Origin" := FromTrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterCopyNewTrackingFromNewTrackingSpec', '', false, false)]
    local procedure OnAfterCopyNewTrackingFromNewTrackingSpec(var TrackingSpecification: Record "Tracking Specification"; FromTrackingSpecification: Record "Tracking Specification")
    begin
        TrackingSpecification."Pallet No." := FromTrackingSpecification."Pallet No.";
        TrackingSpecification."Country Of Origin" := FromTrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterInitFromItemJnlLine', '', false, false)]
    local procedure OnAfterInitFromItemJnlLine(var TrackingSpecification: Record "Tracking Specification"; ItemJournalLine: Record "Item Journal Line")
    begin
        TrackingSpecification."Pallet No." := ItemJournalLine."Pallet No.";
        TrackingSpecification."Country Of Origin" := ItemJournalLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromReservEntry1(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry."Pallet No." := FromReservationEntry."Pallet No.";
        ReservationEntry."Country Of Origin" := FromReservationEntry."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromSpec1(var ItemJournalLine: Record "Item Journal Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemJournalLine."Pallet No." := TrackingSpecification."Pallet No.";
        ItemJournalLine."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnSplitItemJnlLineOnBeforeInsertTempTrkgSpecification', '', false, false)]
    local procedure OnSplitItemJnlLineOnBeforeInsertTempTrkgSpecification(var TempTrackingSpecification: Record "Tracking Specification" temporary; ItemJnlLine2: Record "Item Journal Line"; SignFactor: Integer)
    begin
        TempTrackingSpecification."Pallet No." := ItemJnlLine2."Pallet No.";
        TempTrackingSpecification."Country Of Origin" := ItemJnlLine2."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyNewTrackingFromNewSpec', '', false, false)]
    local procedure OnAfterCopyNewTrackingFromNewSpec(var ItemJournalLine: Record "Item Journal Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemJournalLine."Pallet No." := TrackingSpecification."Pallet No.";
        ItemJournalLine."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromItemJnlLine', '', false, false)]
    local procedure OnAfterCopyTrackingFromItemJnlLine(var ItemTrackingSetup: Record "Item Tracking Setup"; ItemJnlLine: Record "Item Journal Line")
    begin
        ItemTrackingSetup."Pallet No." := ItemJnlLine."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := ItemJnlLine."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnInitWhseJnlLineCopyFromItemJnlLine', '', false, false)]
    local procedure OnInitWhseJnlLineCopyFromItemJnlLine(var WarehouseJournalLine: Record "Warehouse Journal Line"; ItemJournalLine: Record "Item Journal Line")
    begin
        WarehouseJournalLine."Pallet No." := ItemJournalLine."Pallet No.";
        WarehouseJournalLine."Country Of Origin" := ItemJournalLine."Country Of Origin";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Item Tracking Setup", 'OnAfterCopyTrackingFromNewTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromNewTrackingSpec(var ItemTrackingSetup: Record "Item Tracking Setup"; TrackingSpecification: Record "Tracking Specification")
    begin
        ItemTrackingSetup."Pallet No." := TrackingSpecification."Pallet No.";
        ItemTrackingSetup."Country Of Origin" := TrackingSpecification."Country Of Origin";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Journal Line", 'OnAfterCopyNewTrackingFromItemTrackingSetupIfRequired', '', false, false)]
    local procedure OnAfterCopyNewTrackingFromItemTrackingSetupIfRequired(var WhseJnlLine: Record "Warehouse Journal Line"; WhseItemTrackingSetup: Record "Item Tracking Setup")
    begin
        WhseJnlLine."Pallet No." := WhseItemTrackingSetup."Pallet No.";
        WhseJnlLine."Country Of Origin" := WhseItemTrackingSetup."Country Of Origin";
    end;

}
