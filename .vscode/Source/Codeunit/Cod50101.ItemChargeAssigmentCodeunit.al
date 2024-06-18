codeunit 50101 "Item Charge Assigment Codeunit"
{
    procedure CreateRcptChargeAssgnt(var FromOrderLine: Record "Purchase Line"; ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    var
        ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)";
        NextLine: Integer;
        IsHandled: Boolean;
    begin

        FromOrderLine.TestField("Work Center No.", '');
        NextLine := ItemChargeAssgntPurch."Line No.";
        ItemChargeAssgntPurch2.SetRange("Document Type", ItemChargeAssgntPurch."Document Type");
        ItemChargeAssgntPurch2.SetRange("Document No.", ItemChargeAssgntPurch."Document No.");
        ItemChargeAssgntPurch2.SetRange("Document Line No.", ItemChargeAssgntPurch."Document Line No.");
        ItemChargeAssgntPurch2.SetRange(
          "Applies-to Doc. Type", ItemChargeAssgntPurch2."Applies-to Doc. Type"::Order);
        repeat
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. No.", FromOrderLine."Document No.");
            ItemChargeAssgntPurch2.SetRange("Applies-to Doc. Line No.", FromOrderLine."Line No.");
            if not ItemChargeAssgntPurch2.FindFirst() then
                InsertItemChargeAssignment(
                    ItemChargeAssgntPurch, ItemChargeAssgntPurch2."Applies-to Doc. Type"::Order,
                    FromOrderLine."Document No.", FromOrderLine."Line No.",
                    FromOrderLine."No.", FromOrderLine.Description, NextLine);
        until FromOrderLine.Next() = 0;
    end;

    procedure InsertItemChargeAssignment(ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; ApplToDocType: Enum "Purchase Applies-to Document Type"; ApplToDocNo2: Code[20]; ApplToDocLineNo2: Integer; ItemNo2: Code[20]; Description2: Text[100]; var NextLineNo: Integer)
    begin
        InsertItemChargeAssignmentWithValues(
          ItemChargeAssgntPurch, ApplToDocType, ApplToDocNo2, ApplToDocLineNo2, ItemNo2, Description2, 0, 0, NextLineNo);
    end;

    procedure InsertItemChargeAssignmentWithValues(FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; ApplToDocType: Enum "Purchase Applies-to Document Type"; FromApplToDocNo: Code[20]; FromApplToDocLineNo: Integer; FromItemNo: Code[20]; FromDescription: Text[100]; QtyToAssign: Decimal; AmountToAssign: Decimal; var NextLineNo: Integer)
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    begin
        InsertItemChargeAssignmentWithValuesTo(
          FromItemChargeAssgntPurch, ApplToDocType, FromApplToDocNo, FromApplToDocLineNo, FromItemNo, FromDescription,
          QtyToAssign, AmountToAssign, NextLineNo, ItemChargeAssgntPurch);
    end;

    procedure InsertItemChargeAssignmentWithValuesTo(
        FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; ApplToDocType: Enum "Purchase Applies-to Document Type";
        FromApplToDocNo: Code[20]; FromApplToDocLineNo: Integer; FromItemNo: Code[20]; FromDescription: Text[100];
        QtyToAssign: Decimal; AmountToAssign: Decimal; var NextLineNo: Integer; var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    begin
        NextLineNo := NextLineNo + 10000;

        ItemChargeAssgntPurch."Document No." := FromItemChargeAssgntPurch."Document No.";
        ItemChargeAssgntPurch."Document Type" := FromItemChargeAssgntPurch."Document Type";
        ItemChargeAssgntPurch."Document Line No." := FromItemChargeAssgntPurch."Document Line No.";
        ItemChargeAssgntPurch."Item Charge No." := FromItemChargeAssgntPurch."Item Charge No.";
        ItemChargeAssgntPurch."Line No." := NextLineNo;
        ItemChargeAssgntPurch."Applies-to Doc. No." := FromApplToDocNo;
        ItemChargeAssgntPurch."Applies-to Doc. Type" := ApplToDocType;
        ItemChargeAssgntPurch."Applies-to Doc. Line No." := FromApplToDocLineNo;
        ItemChargeAssgntPurch."Item No." := FromItemNo;
        ItemChargeAssgntPurch.Description := FromDescription;
        ItemChargeAssgntPurch."Unit Cost" := FromItemChargeAssgntPurch."Unit Cost";
        if QtyToAssign <> 0 then begin
            ItemChargeAssgntPurch."Amount to Assign" := AmountToAssign;
            ItemChargeAssgntPurch.Validate("Qty. to Assign", QtyToAssign);
        end;
        ItemChargeAssgntPurch.Insert();
    end;

    procedure UpdateExpirationDate(LotNoInformation: Record "Lot No. Information")
    var
        ItemJournalLine: Record "Item Journal Line";
        ItemLedEntry: Record "Item Ledger Entry";
        Quantity: Decimal;
        ItemTrackingSpecification: Record "Tracking Specification";
        InventorySetup: Record "Inventory Setup";
        ItemNo: Code[20];
        TempReservationEntry: Record "Reservation Entry" temporary;
        LotNo: Code[20];
        NothingtoCreateErr: Label 'Nothing to Create.';
        LotNoExistErr: Label 'Lot Information already exist for Line %1';
        ItemJournalPost: Codeunit "Item Jnl.-Post Batch";
        Noseriesmanagement: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocNo: Code[20];
        JournalBatch: Record "Item Journal Batch";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LineNo: Integer;
        EntryNo: Integer;
    begin
        LineNo := 10000;
        LotNoInformation.TestField("New Expiration Date");
        InventorySetup.Get();
        InventorySetup.TestField("Reclas. Journal Template");
        InventorySetup.TestField("Reclassification Journal Batch");
        ItemJournalLine.Reset();
        ItemJournalLine.SetRange("Journal Template Name", InventorySetup."Reclas. Journal Template");
        ItemJournalLine.SetRange("Journal Batch Name", InventorySetup."Reclassification Journal Batch");
        if ItemJournalLine.FindSet() then
            ItemJournalLine.DeleteAll(true);
        ItemLedEntry.Reset();
        ItemLedEntry.SetRange("Lot No.", LotNoInformation."Lot No.");
        ItemLedEntry.SetFilter("Remaining Quantity", '>0');
        if ItemLedEntry.FindSet() then begin
            repeat
                Quantity := ItemLedEntry."Remaining Quantity";
                ItemJournalLine.Init();
                ItemJournalLine."Journal Template Name" := InventorySetup."Reclas. Journal Template";
                ItemJournalLine."Journal Batch Name" := InventorySetup."Reclassification Journal Batch";
                ItemJournalLine."Line No." := LineNo;
                ItemJournalLine.Insert();
                JournalBatch.Reset();
                JournalBatch.SetRange("Journal Template Name", InventorySetup."Reclas. Journal Template");
                JournalBatch.SetRange(Name, InventorySetup."Reclassification Journal Batch");
                if JournalBatch.FindFirst() then begin
                    DocNo := NoSeriesMgt.GetNextNo(InventorySetup."Reclas. No. Series", Today, true);
                end;
                ItemJournalLine.Validate("Entry Type", Enum::"Item Ledger Entry Type"::Transfer);
                ItemJournalLine."Document No." := DocNo;
                ItemJournalLine.Validate("Posting Date", Today);
                ItemJournalLine.Validate(ItemJournalLine."Item No.", ItemLedEntry."Item No.");
                ItemJournalLine.Validate("Location Code", ItemLedEntry."Location Code");
                ItemJournalLine.Validate(Quantity, Quantity);
                ItemJournalLine.Validate("Lot No.", ItemLedEntry."Lot No.");
                ItemJournalLine.Validate("New Item Expiration Date", LotNoInformation."New Expiration Date");
                ItemJournalLine.Validate("Expiration Date", ItemLedEntry."Expiration Date");
                ItemJournalLine.Modify();
                TempReservationEntry.Init();
                if TempReservationEntry.FindLast() then
                    EntryNo := TempReservationEntry."Entry No." + 1
                else
                    EntryNo := 1;
                TempReservationEntry."Entry No." := EntryNo;
                TempReservationEntry."Lot No." := LotNoInformation."Lot No.";
                TempReservationEntry."New Lot No." := ItemLedEntry."Lot No.";
                TempReservationEntry."Expiration Date" := ItemLedEntry."Expiration Date";
                TempReservationEntry.Quantity := Quantity;
                TempReservationEntry.Insert();
                CreateReservEntry.SetNewExpirationDate(LotNoInformation."New Expiration Date");
                CreateReservEntry.SetDates(0D, ItemLedEntry."Expiration Date");
                CreateReservEntry.CreateReservEntryFor(Database::"Item Journal Line", 4, ItemJournalLine."Journal Template Name", ItemJournalLine."Journal Batch Name",
                0, ItemJournalLine."Line No.", ItemJournalLine."Qty. per Unit of Measure", Quantity, Quantity, TempReservationEntry);
                CreateReservEntry.SetNewTrackingFromItemJnlLine(ItemJournalLine);
                CreateReservEntry.SetApplyToEntryNo(ItemLedEntry."Entry No.");
                CreateReservEntry.CreateEntry(ItemJournalLine."Item No.", '', ItemJournalLine."Location Code", ItemJournalLine.Description, 0D, 0D, 0, Enum::"Reservation Status"::Prospect);
                if ItemLedEntry.Next() <> 0 then begin
                    LineNo := LineNo + 10000;
                end;
                ItemJournalLine.Modify();
            until ItemLedEntry.Next() = 0;
        end;
        ItemJournalPost.Run(ItemJournalLine);
        Message('Expiration Updated Successfully');
    end;

}
