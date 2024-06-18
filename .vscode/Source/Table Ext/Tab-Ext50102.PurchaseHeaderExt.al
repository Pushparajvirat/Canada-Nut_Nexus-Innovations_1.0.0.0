tableextension 50102 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        field(50100; "Created By Name"; Code[50])
        {
            Caption = 'Created By Name';
            DataClassification = ToBeClassified;
        }
        field(50122; SKID; Code[20])
        {
            Caption = 'SKID';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Type".Code;
            ValidateTableRelation = false;
        }
        field(50123; "Shipping Line"; Code[20])
        {
            Caption = 'Shipping Line';
            DataClassification = ToBeClassified;
            TableRelation = "Shipping Line".Code;
            ValidateTableRelation = false;
        }
        field(50124; "Incoterm"; Code[20])
        {
            Caption = 'Incoterm';
            DataClassification = ToBeClassified;
            TableRelation = Incoterm.Code;
            ValidateTableRelation = false;
        }
        field(50101; "Container ID"; Code[20])
        {
            Caption = 'Container ID';
            DataClassification = ToBeClassified;
        }
        field(50102; ETD; Date)
        {
            Caption = 'ETD';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Rec."Delivery Expected Date" <> 0D then begin
                    Rec."Transit Time" := Rec."Delivery Expected Date" - Rec.ETD;
                end;
            end;
        }
        field(50103; "Transit Time"; Integer)
        {
            Caption = 'Transit Time';
            DataClassification = ToBeClassified;

        }
        field(50104; "Freight Forwarder"; Text[100])
        {
            Caption = 'Freight Forwarder';
            DataClassification = ToBeClassified;
            TableRelation = Vendor.Name;
            ValidateTableRelation = false;
        }
        field(50105; Carrier; Text[100])
        {
            Caption = 'Carrier';
            DataClassification = ToBeClassified;
            TableRelation = Vendor.Name;
            ValidateTableRelation = false;
        }
        field(50106; "Total Freight Cost"; Decimal)
        {
            Caption = 'Total Freight Cost - CAD';
            DataClassification = ToBeClassified;
        }
        field(50107; "Transit Port"; Code[20])
        {
            Caption = 'Transit Port';
            DataClassification = ToBeClassified;
            TableRelation = "Transit Port".Code;
            ValidateTableRelation = false;
        }
        field(50108; "ETA Transit Port"; Date)
        {
            Caption = 'ETA Transit Port';
            DataClassification = ToBeClassified;
        }
        field(50109; "ETA POD"; Date)
        {
            Caption = 'ETA POD';
            DataClassification = ToBeClassified;
        }
        field(50110; "Final Destination"; Code[20])
        {
            Caption = 'Final Destination';
            DataClassification = ToBeClassified;
            TableRelation = "Transit Port".Code;
            ValidateTableRelation = false;
        }
        field(50111; "Delivery Expected Date"; Date)
        {
            Caption = 'ETA To LAVAL';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Rec.ETD <> 0D then begin
                    Rec."Transit Time" := Rec."Delivery Expected Date" - Rec.ETD;
                end;
            end;
        }
        field(50112; Deposit; Decimal)
        {
            Caption = 'Deposit';
            DataClassification = ToBeClassified;
        }
        field(50113; "Confirmation Payment"; Option)
        {
            Caption = 'Confirmation Payment';
            DataClassification = ToBeClassified;
            OptionMembers = " ","Deposit Paid","Full Paid";
        }
        field(50114; "OBL Issued Via Courier Service"; Date)
        {
            Caption = 'OBL Issued Via Courier Service';
            DataClassification = ToBeClassified;
        }
        field(50115; "Steam Ship Released"; Date)
        {
            Caption = 'Steam Ship Released';
            DataClassification = ToBeClassified;
        }
        field(50116; "Custom Released"; Date)
        {
            Caption = 'Custom Released';
            DataClassification = ToBeClassified;
        }
        field(50117; "LFD Pickup"; Date)
        {
            Caption = 'LFD Pickup';
            DataClassification = ToBeClassified;
        }
        field(50118; "LFD Return"; Date)
        {
            Caption = 'LFD Return';
            DataClassification = ToBeClassified;
        }
        field(50119; EIR; Date)
        {
            Caption = 'EIR';
            DataClassification = ToBeClassified;
        }
        field(50120; "Return place"; Code[20])
        {
            Caption = 'Return place';
            DataClassification = ToBeClassified;
            TableRelation = "Return Place".Code;
            ValidateTableRelation = false;
        }
        field(50121; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50125; "Start Date"; Date)
        {
            Caption = 'Start Date';
            DataClassification = ToBeClassified;
        }
        field(50126; "End Date"; Date)
        {
            Caption = 'End Date';
            DataClassification = ToBeClassified;
        }
        field(50127; "Total Weight By Line in LBS"; Decimal)
        {
            Caption = 'Total Weight By Line in LBS';
            DataClassification = ToBeClassified;
        }
        field(50128; "Weight in LBS"; Decimal)
        {
            Caption = 'Weight in LBS';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Weight in LBS" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50129; "Contract Qty."; Decimal)
        {
            Caption = 'Total Contract Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("Document No." = field("No.")));
            Editable = false;
        }
        field(50130; "Total Order Qty."; Decimal)
        {
            Caption = 'Total Order Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Order Qty." where("Document No." = field("No.")));
            Editable = false;
        }
        field(50131; "Total Balance Qty."; Decimal)
        {
            Caption = 'Total Balance Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Balance Qty." where("Document No." = field("No.")));
            Editable = false;
        }
        field(50132; "Price Per Pound"; Decimal)
        {
            Caption = 'Price Per Pound';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Price Per Pound" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50133; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            FieldClass = FlowField;
            CalcFormula = lookup("Purchase Line"."Item Category Code" where("Document No." = field("No."), "Line No." = const(10000)));
            Editable = false;
        }
        field(50134; "Container Inspection"; Boolean)
        {
            Caption = 'Container Inspection';
            DataClassification = ToBeClassified;
        }
        field(50135; "Weight in KG"; Decimal)
        {
            Caption = 'Weight in KG';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Weight in KG" where("Document No." = field("No.")));
            Editable = false;
        }
        field(50136; "Advance Voucher No."; Code[20])
        {
            Caption = 'Advance Voucher No.';
            DataClassification = ToBeClassified;
        }
        field(50137; "Advance Amount"; Decimal)
        {
            Caption = 'Advance Amount';
            DataClassification = ToBeClassified;
        }
        field(50138; "Advance Invoice"; boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Advance Invoice';
        }
        field(50139; "Advance %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Advance %';
            trigger OnValidate()
            begin
                TestField("Advance Voucher No.", '');
                CalcFields(Amount);
                Rec."Advance Amount" := (Rec.Amount * Rec."Advance %") / 100;
            end;
        }
        modify("Prepayment %")
        {
            trigger OnAfterValidate()
            begin
                Rec.CalcFields(Amount);
                Rec.Deposit := (Rec."Prepayment %" / 100) * Rec.Amount;
            end;
        }
        modify("Currency Code")
        {
            trigger OnAfterValidate()
            var
                Currencies: Record "Currency Exchange Rate";
            begin
                Currencies.Reset();
                Currencies.SetRange("Currency Code", Rec."Currency Code");
                if Currencies.FindLast() then
                    Rec."Exchange Rate" := Currencies."Relational Exch. Rate Amount";
            end;
        }
    }
    trigger OnAfterInsert()
    begin
        rec."Created By Name" := UserId;
        Modify();
    end;

    procedure CreateAdvanceInvoiceHeader(var RecPurchHeader: Record "Purchase Header"; AdvanceNo: code[20])
    var
        PurchasePayabeSetup: Record "Purchases & Payables Setup";
    begin
        TestField("Advance Amount");
        PurchasePayabeSetup.get();
        RecPurchHeader.Init();
        RecPurchHeader."Document Type" := RecPurchHeader."Document Type"::Invoice;
        RecPurchHeader."No." := AdvanceNo;
        RecPurchHeader.Insert(true);
        RecPurchHeader.Validate("Buy-from Vendor No.", "Buy-from Vendor No.");
        RecPurchHeader."Posting No. Series" := PurchasePayabeSetup."Advance No. Series";
        RecPurchHeader.Validate("Document Date", "Document Date");
        RecPurchHeader.Validate("Posting Date", "Order Date");
        RecPurchHeader.Validate("Payment Terms Code", "Payment Terms Code");
        RecPurchHeader.Validate("Shipment Method Code", "Shipment Method Code");
        RecPurchHeader.Validate("Currency Code", "Currency Code");
        RecPurchHeader.Validate("Currency Factor", "Currency Factor");
        RecPurchHeader.Validate("Advance Invoice", true);
        RecPurchHeader."Vendor Invoice No." := Rec."No." + '/' + Format(Time);
        RecPurchHeader.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
        RecPurchHeader.Modify();
    End;

    procedure CreateAdvanceInvoiceLine(LineAmt: Decimal; PONo: Code[20])
    var
        RecPurchaseLine: Record "Purchase Line";
        PurchasePayableSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        ContainNo: COde[20];
    begin
        PurchasePayableSetup.Get();
        PurchasePayableSetup.TestField("Advance Account");
        RecPurchaseLine.Init();
        RecPurchaseLine."Document Type" := RecPurchaseLine."Document Type"::Invoice;
        RecPurchaseLine."Document No." := PONo;
        RecPurchaseLine."Line No." := 10000;
        RecPurchaseLine.Insert();
        RecPurchaseLine.Validate(Type, RecPurchaseLine.Type::"G/L Account");
        RecPurchaseLine.Validate("No.", PurchasePayableSetup."Advance Account");
        RecPurchaseLine.Validate(Quantity, 1);
        RecPurchaseLine.Validate("Direct Unit Cost", LineAmt);
        RecPurchaseLine.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
        RecPurchaseLine.Modify();
    End;

    procedure updateAdvanceAmount()
    var
        Purchaseline: Record "Purchase Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AmountReceived: Decimal;
        DetailedVendorLedEntry: Record "Detailed Vendor Ledg. Entry";
        RecVoucherNo: Code[20];
    begin
        Purchaseline.Reset();
        Purchaseline.SetRange("Document No.", "No.");
        Purchaseline.SetFilter("Quantity Invoiced", '%1', 0);
        if Purchaseline.FindFirst() then
            repeat
                VendorLedgerEntry.Reset();
                VendorLedgerEntry.SetRange("Document No.", Purchaseline."Advance Voucher No.");
                if VendorLedgerEntry.FindFirst() then begin
                    VendorLedgerEntry.CalcFields(Amount, "Remaining Amount");
                    AmountReceived := abs(VendorLedgerEntry.Amount - VendorLedgerEntry."Remaining Amount");
                    DetailedVendorLedEntry.Reset();
                    DetailedVendorLedEntry.SetRange(DetailedVendorLedEntry."Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                    DetailedVendorLedEntry.SetRange("Entry Type", DetailedVendorLedEntry."Entry Type"::Application);
                    if DetailedVendorLedEntry.FindFirst() then
                        RecVoucherNo := DetailedVendorLedEntry."Document No.";
                end;
                if "Advance Amount" > 0 then begin
                    Purchaseline."Amount Paid New" := (Purchaseline."Advance Amount" / "Advance Amount") * AmountReceived;
                    Purchaseline."Rec Amt Voucher No." := RecVoucherNo;
                    Purchaseline.Modify();
                end;
            until Purchaseline.Next() = 0;
    end;


}
