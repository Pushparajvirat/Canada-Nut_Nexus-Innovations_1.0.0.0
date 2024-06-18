codeunit 50102 "Reservation Codeunit"
{
    procedure UpdateSalesOrderCost(Var SalesLine: Record "Sales Line")
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ItemChargeAssignment: Record "Item Charge Assignment (Purch)";
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchaseLine: Record "Purchase Line";
        ValueEntry: Record "Value Entry";
        ILEMaterialCost: Decimal;
        ILEFreightCost: Decimal;
        PurchaseMetrialCost: Decimal;
        PurchaseFreightCOst: Decimal;
        TotalLandedCost: Decimal;
        ILECount: Integer;
        POCount: Integer;
    begin
        ILEMaterialCost := 0;
        ILEFreightCost := 0;
        PurchaseMetrialCost := 0;
        PurchaseFreightCOst := 0;
        TotalLandedCost := 0;
        ILECount := 0;
        ReservationEntry.Reset();
        ReservationEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."Reservation Status"::Reservation);
        if ReservationEntry.FindSet() then begin
            repeat
                ReservationEntry2.Reset();
                ReservationEntry2.SetRange("Entry No.", ReservationEntry."Entry No.");
                ReservationEntry2.SetRange(Positive, true);
                if ReservationEntry2.FindSet() then begin
                    repeat
                        if ReservationEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Item Ledger Entry No.", ReservationEntry2."Source Ref. No.");
                            ValueEntry.SetFilter("Item Charge No.", '%1', '');
                            if ValueEntry.FindSet() then
                                repeat
                                    ILEMaterialCost += (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity");
                                until ValueEntry.Next() = 0;
                            ValueEntry.Reset();
                            ValueEntry.SetRange("Item Ledger Entry No.", ReservationEntry2."Source Ref. No.");
                            ValueEntry.SetFilter("Item Charge No.", '<>%1', '');
                            if ValueEntry.FindSet() then
                                repeat
                                    ILEFreightCost += (ValueEntry."Cost Amount (Actual)" / ValueEntry."Valued Quantity");
                                until ValueEntry.Next() = 0;
                            ILECount := ILECount + 1;
                        end;
                        if ReservationEntry2."Source Type" = Database::"Purchase Line" then begin
                            PurchaseLine.Reset();
                            PurchaseLine.SetRange("Document No.", ReservationEntry2."Source ID");
                            PurchaseLine.SetRange("Line No.", ReservationEntry2."Source Ref. No.");
                            if PurchaseLine.FindFirst() then
                                PurchaseMetrialCost += PurchaseLine."Direct Unit Cost";
                            ItemChargeAssignment.Reset();
                            ItemChargeAssignment.SetRange("Document No.", PurchaseLine."Document No.");
                            ItemChargeAssignment.SetRange("Item No.", PurchaseLine."No.");
                            if ItemChargeAssignment.FindSet() then
                                repeat
                                    PurchaseFreightCOst += ItemChargeAssignment."Amount to Assign";
                                until ItemChargeAssignment.Next() = 0;
                            POCount := POCount + 1;
                        end
                    until ReservationEntry2.Next() = 0;
                end;
            until ReservationEntry.Next() = 0;
        end;

        PurchaseMetrialCost := PurchaseMetrialCost / POCount;
        PurchaseFreightCOst := PurchaseFreightCOst / POCount;
        ILEMaterialCost := ILEMaterialCost / ILECount;
        ILEFreightCost := ILEFreightCost / ILECount;
        TotalLandedCost := ILEMaterialCost + ILEFreightCost + PurchaseMetrialCost + PurchaseFreightCOst;
        SalesLine."Material Cost" := ILEMaterialCost + PurchaseMetrialCost;
        SalesLine."Freight Cost" := ILEFreightCost + PurchaseFreightCOst;
        SalesLine."Landed Cost" := TotalLandedCost;
        SalesLine.Modify();
    end;
}
