report 50103 "Rebate Posting"
{
    ApplicationArea = All;
    Caption = 'Rebate Posting';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(General)
                {
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Customer No.';
                        TableRelation = Customer."No.";
                    }
                    field(RebateCode; RebateCode)
                    {
                        ApplicationArea = all;
                        Caption = 'Rebate Code';
                        TableRelation = "Rebate Header".Code;
                    }
                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        ApplicationArea = all;
                        Caption = 'Item Category Code';
                        TableRelation = "Item Category".Code;
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    var
        RebateLedgerEntry: Record "Rebate Ledger Entry";
        SalesHeader: Record "Sales Header";
        Salesline: Record "Sales Line";
        CustomerNumber: Code[20];
        RebateLedgerEntry1: Record "Rebate Ledger Entry";
        Noseriesmanagerment: Codeunit NoSeriesManagement;
        SalesReceivableSetup: Record "Sales & Receivables Setup";
        SalesPost: Codeunit "Sales-Post";
    begin
        SalesReceivableSetup.Get();
        RebateLedgerEntry.Reset();
        if CustomerNo <> '' then
            RebateLedgerEntry.SetRange("Customer No.", CustomerNo);
        if RebateCode <> '' then
            RebateLedgerEntry.SetRange("Rebate Code", RebateCode);
        if ItemCategoryCode <> '' then
            RebateLedgerEntry.SetRange("Item Category Code", ItemCategoryCode);
        RebateLedgerEntry.SetRange("Rebate Posted", false);
        if RebateLedgerEntry.FindSet() then begin
            repeat
                if CustomerNumber <> RebateLedgerEntry."Customer No." then begin
                    RebateLedgerEntry1.Copy(RebateLedgerEntry);
                    RebateLedgerEntry1.SetRange("Customer No.", RebateLedgerEntry."Customer No.");
                    if RebateLedgerEntry1.FindSet() then begin
                        RebateLedgerEntry1.CalcSums("Rebate Amount");
                        SalesHeader.Init();
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader."No." := Noseriesmanagerment.GetNextNo(SalesReceivableSetup."Credit Memo Nos.", Today, true);
                        SalesHeader.Insert();
                        SalesHeader.Validate("Sell-to Customer No.", RebateLedgerEntry1."Customer No.");
                        SalesHeader.Validate("Posting Date", Today);
                        SalesHeader.Modify();
                        Salesline.Init();
                        Salesline."Document Type" := SalesHeader."Document Type";
                        Salesline."Document No." := SalesHeader."No.";
                        Salesline."Line No." := 10000;
                        Salesline.Insert();
                        Salesline.Validate(Type, Salesline.Type::"G/L Account");
                        Salesline.Validate("No.", RebateLedgerEntry1."Rebate Expense Account");
                        Salesline.Validate(Quantity, 1);
                        Salesline.Validate("Unit Price", RebateLedgerEntry1."Rebate Amount");
                        Salesline.Modify();
                        SalesPost.Run(SalesHeader);
                        RebateLedgerEntry1.ModifyAll(RebateLedgerEntry1."Rebate Posted", true);
                    end;
                    CustomerNumber := RebateLedgerEntry."Customer No.";
                end;
            until RebateLedgerEntry.Next() = 0;
        end;
    end;

    var
        CustomerNo: Code[20];
        RebateCode: Code[20];
        ItemCategoryCode: Code[20];
}
