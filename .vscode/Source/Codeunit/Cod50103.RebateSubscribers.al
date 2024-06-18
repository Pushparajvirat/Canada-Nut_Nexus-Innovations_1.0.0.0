codeunit 50103 "Rebate Subscribers"
{
    Permissions = tabledata "G/L Entry" = RIMD;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean; var IsHandled: Boolean)
    var
        Customer: Record Customer;
        RebateHeader: Record "Rebate Header";
        RebateLine: Record "Rebate Lines";
        SalesLine: Record "Sales Line";
        RebateAmount: Decimal;
    begin
        if SalesHeader.Invoice then begin
            Clear(RebateAmount);
            Customer.Get(SalesHeader."Sell-to Customer No.");
            if Customer."Rebate Group" = '' then
                exit;
            if RebateHeader.Get(SalesHeader."Rebate Code") then begin
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                if SalesLine.FindSet() then begin
                    if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::Accural then begin
                        repeat
                            RebateAmount += GetSalesRebateAmount(SalesLine, RebateHeader."Rebate Type", true);
                        until SalesLine.Next() = 0;
                    end;
                end;
                if PreviewMode = Not True then
                    if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::Accural then begin
                        CreateRebateJournal(RebateAmount, Customer, SalesHeader, RebateHeader.Code, SalesLine);
                    end;
                // end else begin
                //     InsertSalesLine(RebateAmount, Customer, SalesHeader, RebateHeader, SalesLine);
                // end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer; var SkipBillToContact: Boolean; var SkipSellToContact: Boolean)
    var
        RebateHeader: Record "Rebate Header";
    begin
        if (SalesHeader."Document Type" = (SalesHeader."Document Type"::Order)) or (SalesHeader."Document Type" = (SalesHeader."Document Type"::"Credit Memo")) then begin
            RebateHeader.Reset();
            RebateHeader.SetRange("Rebate Group", SellToCustomer."Rebate Group");
            if RebateHeader.FindFirst() then begin
                SalesHeader."Rebate Code" := RebateHeader.Code;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Line Amount', false, false)]
    local procedure OnAfterValidateLineAmounr(var Rec: Record "Sales Line")
    var
        Customer: Record Customer;
        RebateHeader: Record "Rebate Header";
        RebateLine: Record "Rebate Lines";
        SalesHeader: Record "Sales Header";
        Salesline: Record "Sales Line";
        RebateAmount: Decimal;
    begin
        if SalesHeader.get(Rec."Document Type", Rec."Document No.") then begin
            Clear(RebateAmount);
            Customer.Get(SalesHeader."Sell-to Customer No.");
            if Customer."Rebate Group" = '' then
                exit;
            if RebateHeader.Get(SalesHeader."Rebate Code") then begin
                Rec."Rebate Amount" := GetSalesRebateAmount(Rec, RebateHeader."Rebate Type", False);
            end;
        end;
    end;


    [EventSubscriber(ObjectType::Page, Page::"Sales Order", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure OnBeforePostSalesOrder(var Rec: Record "Sales Header")
    Var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        RebateHeader: Record "Rebate Header";
        RebateAmount: Decimal;
    begin
        // if SalesHeader.Invoice then begin
        Clear(RebateAmount);
        Customer.Get(Rec."Sell-to Customer No.");
        if Customer."Rebate Group" = '' then
            exit;
        if RebateHeader.Get(Rec."Rebate Code") then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", Rec."No.");
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if SalesLine.FindSet() then begin
                if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::"Off-Invoice" then begin
                    repeat
                        RebateAmount += GetSalesRebateAmount(SalesLine, RebateHeader."Rebate Type", true);
                    until SalesLine.Next() = 0;
                end;
            end;
        end;
        if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::"Off-Invoice" then begin
            InsertSalesLine(RebateAmount, Customer, Rec, RebateHeader, SalesLine);
        end;
        // end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Credit Memo", 'OnBeforeActionEvent', 'Post', false, false)]
    local procedure OnBeforePostSalesCreditnote(var Rec: Record "Sales Header")
    Var
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        RebateHeader: Record "Rebate Header";
        RebateAmount: Decimal;
    begin
        // if SalesHeader.Invoice then begin
        Clear(RebateAmount);
        Customer.Get(Rec."Sell-to Customer No.");
        if Customer."Rebate Group" = '' then
            exit;
        if RebateHeader.Get(Rec."Rebate Code") then begin
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", Rec."No.");
            SalesLine.SetRange("Document Type", Rec."Document Type");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            if SalesLine.FindSet() then begin
                if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::"Off-Invoice" then begin
                    repeat
                        RebateAmount += GetSalesRebateAmount(SalesLine, RebateHeader."Rebate Type", true);
                    until SalesLine.Next() = 0;
                end;
            end;
        end;
        if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::"Off-Invoice" then begin
            InsertSalesLine(RebateAmount, Customer, Rec, RebateHeader, SalesLine);
        end;
        // end;
    end;


    local procedure CreateRebateJournal(Amt: Decimal; Cust: Record Customer; SalesHeader: Record "Sales Header"; RebateCode: Code[20]; Salesline: Record "Sales Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        FieldRef: FieldRef;
        DescTxt: Label 'Rebate accrual for Posted Invoice No %1';
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        RebateHeader: Record "Rebate Header";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        if RebateHeader.Get(RebateCode) then begin
            SalesSetup.Get();
            GenJnlLine.SetRange("Journal Template Name", SalesSetup."Rebate Journal Template");
            GenJnlLine.SetRange("Journal Batch Name", SalesSetup."Rebate Journal Batch");
            GenJnlLine.DeleteAll();
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := SalesSetup."Rebate Journal Template";
            GenJnlLine."Journal Batch Name" := SalesSetup."Rebate Journal Batch";
            GenJnlLine."Line No." := 10000;
            GenJnlLine.Insert(true);
            if GenJnlLine."Document No." = '' then
                GenJnlLine."Document No." := SalesHeader."No.";
            GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::"G/L Account");
            GenJnlLine.Validate("Account No.", RebateHeader."Rebate Accural Account");
            GenJnlLine.Validate("Posting Date", SalesHeader."Posting Date");
            if Salesline."Document Type" = Salesline."Document Type"::Order then
                GenJnlLine.Validate(Amount, Amt);
            if Salesline."Document Type" = Salesline."Document Type"::"Credit Memo" then
                GenJnlLine.Validate(Amount, -Amt);
            GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.Validate("Bal. Account No.", RebateHeader."Rebate Expense Account");
            GenJnlLine.Description := Format(RebateCode) + ' ' + Format(SalesHeader."No.");
            GenJnlLine."External Document No." := RebateCode;
            GenJnlLine.Modify();
            GenJnlPostBatch.RUN(GenJnlLine);
        end;
    end;

    local procedure CreateRebateLedgerEntries(SalesLine: Record "Sales Line"; Customer: Record Customer; RebateAmount: Decimal)
    Var
        RebateLedEntries: Record "Rebate Ledger Entry";
        SalesHeader: Record "Sales Header";
        RebateHeader: Record "Rebate Header";
    begin

        RebateLedEntries.Init();
        RebateLedEntries."Entry No." := GetLastLedgerEntryNo();
        RebateLedEntries."Customer No." := Customer."No.";
        RebateLedEntries."Customer Name" := Customer.Name;
        RebateLedEntries."Invoice Line Amount" := SalesLine."Line Amount";
        RebateLedEntries."Item Category Code" := SalesLine."Item Category Code";
        if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then begin
            RebateLedEntries."Rebate Code" := SalesHeader."Rebate Code";
            RebateLedEntries."Posting Date" := SalesHeader."Posting Date";
            RebateLedEntries."Invoice No." := SalesHeader."Posting No.";
            RebateLedEntries."Document Type" := SalesLine."Document Type";
        end;
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then
            RebateLedEntries."Rebate Amount" := RebateAmount;
        if SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then
            RebateLedEntries."Rebate Amount" := -RebateAmount;
        if RebateHeader.get(SalesHeader."Rebate Code") then begin
            RebateLedEntries."Rebate Expense Account" := RebateHeader."Rebate Expense Account";
            if RebateHeader."Rebate Type" = RebateHeader."Rebate Type"::Accural then
                RebateLedEntries."Rebate Posted" := false
            else
                RebateLedEntries."Rebate Posted" := true;
        end;
        RebateLedEntries.Insert();
    end;

    local procedure GetLastLedgerEntryNo(): Integer
    var
        RebateLedEntries: Record "Rebate Ledger Entry";
    begin
        RebateLedEntries.Reset();
        if RebateLedEntries.FindLast() then
            Exit(RebateLedEntries."Entry No." + 1)
        else
            Exit(1);
    end;

    local procedure GetSalesRebateAmount(SalesLine: Record "Sales Line"; RebateType: Option; CreateRLE: Boolean): Decimal
    var
        SalesHeader: Record "Sales Header";
        RebateLines: Record "Rebate Lines";
        RebateAmount: Decimal;
        customer: Record Customer;
    begin
        Clear(RebateAmount);
        if SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.") then begin
            RebateLines.Reset();
            RebateLines.SetRange("Rebate Code", SalesHeader."Rebate Code");
            RebateLines.SetRange("Item Category Code", SalesLine."Item Category Code");
            if RebateLines.FindFirst() then begin
                if RebateLines."Calculation Base" = RebateLines."Calculation Base"::"Dollar($)" then begin
                    RebateAmount := SalesLine."Net Weight" * RebateLines."Rebate Value";
                end;
                if RebateLines."Calculation Base" = RebateLines."Calculation Base"::"Percentage(%)" then begin
                    RebateAmount := SalesLine."Line Amount" * (RebateLines."Rebate Value") / 100;
                end;
                if customer.get(SalesHeader."Sell-to Customer No.") then begin
                    if CreateRLE then
                        CreateRebateLedgerEntries(SalesLine, Customer, RebateAmount);
                end;
                exit(RebateAmount);
            end;
        end;
    end;

    local procedure InsertSalesLine(RebateAmount: Decimal; Customer: Record Customer; var SalesHeader: Record "Sales Header"; RebateHeader: Record "Rebate Header"; Var SalesLine: Record "Sales Line")
    var
        RecSalesHeader: Record "Sales Header";
        LineNo: Integer;
        RecSalesline: Record "Sales Line";
    begin
        SalesHeader.Status := SalesHeader.Status::Open;
        SalesHeader.Modify();
        RecSalesline.Reset();
        RecSalesline.SetRange("Document No.", SalesHeader."No.");
        RecSalesline.SetRange("Document Type", SalesHeader."Document Type");
        if RecSalesline.FindLast() then begin
            LineNo := RecSalesline."Line No." + 10000;
        end;
        RecSalesline.Init();
        RecSalesline."Document Type" := SalesHeader."Document Type";
        RecSalesline."Document No." := SalesHeader."No.";
        RecSalesline."Line No." := LineNo;
        RecSalesline."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        RecSalesline.Insert();
        RecSalesline.Validate(Type, SalesLine.Type::"G/L Account");
        RecSalesline.Validate("No.", RebateHeader."Rebate Discount Account");
        RecSalesline.Validate(Quantity, 1);
        RecSalesline.Validate("Qty. to Ship", 1);
        RecSalesline.Validate("Qty. to Invoice", 1);
        if RecSalesline."Document Type" = RecSalesline."Document Type"::Order then
            RecSalesline.Validate("Unit Price", -(RebateAmount));
        if RecSalesline."Document Type" = RecSalesline."Document Type"::"Credit Memo" then
            RecSalesline.Validate("Unit Price", (RebateAmount));
        RecSalesline.Modify();
        SalesHeader.Status := SalesHeader.Status::Released;
        SalesHeader.Modify();
    end;

    procedure ChaneExternalDocNo(var GenLedentry: Record "G/L Entry")
    begin
        GenLedentry.SetRange("Document Type", GenLedentry."Document Type"::"Credit Memo");
        if GenLedentry.FindFirst() then begin
            GenLedentry."External Document No." := 'Modified';
            GenLedentry.Modify();
        end;
    end;

}
