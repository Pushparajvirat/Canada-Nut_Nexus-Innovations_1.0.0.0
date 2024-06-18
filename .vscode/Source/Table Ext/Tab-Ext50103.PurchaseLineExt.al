tableextension 50103 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(50100; "Weight in LBS"; Decimal)
        {
            Caption = 'Weight in LBS';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50101; "Balance Qty."; Decimal)
        {
            Caption = 'Balance Qty.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Order Qty."; Decimal)
        {
            Caption = 'Order Qty.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50103; "Price Per Pound"; Decimal)
        {
            Caption = 'Price Per Pound';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50104; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50105; "Lot No."; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = ToBeClassified;
        }
        field(50106; "Indirect Cost Amount"; Decimal)
        {
            Caption = 'Indirect Cost Amount';
            DataClassification = ToBeClassified;
        }
        field(50107; "ETD Date"; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
        }
        field(50108; "Weight in KG"; Decimal)
        {
            Caption = 'Weight in KG';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50109; "Qty. By Pallet"; Decimal)
        {
            Caption = 'Qty. in Pallet';
            DataClassification = ToBeClassified;
        }
        field(50110; "Advance Voucher No."; Code[20])
        {
            Caption = 'Advance Voucher No.';
            DataClassification = ToBeClassified;
        }
        field(50111; "Advance Amount"; Decimal)
        {
            Caption = 'Advance Amount';
            DataClassification = ToBeClassified;
        }
        field(50112; "Adv. Reversal Posted"; Boolean)
        {
            Caption = 'Adv. Reversal Posted';
            DataClassification = ToBeClassified;
        }
        field(50113; "Rec Amt Voucher No."; Code[20])
        {
            Caption = 'Payment Voucher No.';
        }
        field(50114; "Amount Paid New"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance Amount Paid';
        }
        field(50115; "Transport Cost"; Decimal)
        {
            Caption = 'Transport Cost';
            FieldClass = FlowField;
            CalcFormula = sum("Item Charge Assignment (Purch)"."Amount to Assign" where("Applies-to Doc. No." = field("Document No."), "Applies-to Doc. Line No." = field("Line No."), "Item No." = field("No.")));
        }
        field(50116; "Country of Origin"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Country of Origin';
            TableRelation = "Country/Region".Code;
        }
        field(50117; "Price Per Kg"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Price Per Kg';
        }
        field(50118; "PurchaseUOM"; Code[10])
        {
            Caption = 'Purchase UOM';
            DataClassification = ToBeClassified;
            TableRelation = IF (Type = CONST(Item),
                                "No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            if (Type = const(Resource), "No." = filter(<> '')) "Resource Unit of Measure".Code where("Resource No." = field("No."))
            else
            if (Type = filter("Charge (Item)" | "Fixed Asset" | "G/L Account")) "Unit of Measure";
        }
        field(50119; "Status Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Status Code';
            TableRelation = Status.Code;
        }

        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                if (Rec."Direct Unit Cost" <> 0) And (Rec."Weight in LBS" <> 0) then
                    Rec."Price Per Pound" := (Rec."Line Amount" / Rec."Weight in LBS");
            end;
        }
    }
    procedure CreateReservationEntry(ItemNo: Code[20]; LocationCode: Code[10]; QtytoReceiveBase: Decimal; SourceType: Integer; SubType: Integer;
            Desc: Text; DocumentNo: code[20]; LineNo: Integer; QtyPerUnit: decimal; QtytoReceive: Decimal; NewLotNo: Code[20]; Pos: Boolean; BatchName: Code[10]; ReservationStatus: Integer; PostingDate: Date; VariantCode: Code[20]; CountryOfOrigin: Code[20]; Netweight: Decimal; StatusCode: Code[20])
    var
        ReservationEntry: Record "Reservation Entry";
        ReserveEntryNo: Integer;
    begin
        if ReservationEntry.FindLast() then
            ReserveEntryNo := ReservationEntry."Entry No." + 1
        else
            ReserveEntryNo := 1;

        ReservationEntry.Reset();

        ReservationEntry."Entry No." := ReserveEntryNo;
        ReservationEntry.Positive := Pos;
        ReservationEntry."Item No." := ItemNo;
        ReservationEntry."Location Code" := LocationCode;
        ReservationEntry."Quantity (Base)" := QtytoReceiveBase;
        if ReservationStatus = 3 then
            ReservationEntry."Reservation Status" := "Reservation Status"::Prospect;
        if ReservationStatus = 2 then
            ReservationEntry."Reservation Status" := "Reservation Status"::Surplus;
        ReservationEntry.Description := Desc;
        ReservationEntry."Creation Date" := today;
        ReservationEntry."Source Type" := SourceType;
        ReservationEntry."Source Subtype" := SubType;
        ReservationEntry."Source ID" := DocumentNo;
        ReservationEntry."Source Ref. No." := LineNo;
        ReservationEntry."Source Batch Name" := BatchName;
        ReservationEntry."Created By" := UserId();
        ReservationEntry."Qty. per Unit of Measure" := QtyPerUnit;
        ReservationEntry.Quantity := QtytoReceive;
        ReservationEntry."Qty. to Handle (Base)" := QtytoReceiveBase;
        ReservationEntry."Qty. to Invoice (Base)" := QtytoReceiveBase;
        ReservationEntry."Lot No." := NewLotNo;
        ReservationEntry."Variant Code" := VariantCode;
        ReservationEntry."Status Code" := StatusCode;
        ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
        if PostingDate <> 0D then
            ReservationEntry."Shipment Date" := PostingDate
        else begin
            ReservationEntry."Shipment Date" := 0D;
            ReservationEntry."Expected Receipt Date" := Today;
        end;
        ReservationEntry.Insert();
        ReservationEntry."Country Of Origin" := CountryOfOrigin;
        ReservationEntry."Net Weight" := Netweight;
        ReservationEntry.Modify();
    end;
}
