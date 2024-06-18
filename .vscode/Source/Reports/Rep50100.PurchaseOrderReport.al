report 50100 "Purchase Order Report"
{
    ApplicationArea = All;
    Caption = 'Local Purchase Order';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './.vscode/Source/Layouts/LocalPurchaseOrder.rdl';
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "No.", "Buy-from Vendor No.";
            column(No_; "No.") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_Contact_No_; "Buy-from Contact No.") { }
            column(CompanyInformationPic; CompanyInformation.Picture) { }
            column(CompanyInformationName; CompanyInformation.Name) { }
            column(CompanyInformationAddress; CompanyInformation.Address) { }
            column(CompanyInformationAddress2; CompanyInformation."Address 2") { }
            column(CompanyInformationPostCode; CompanyInformation."Post Code") { }
            column(CompanyInformationCountry; CompanyInformation."Country/Region Code") { }
            column(CompanyInformationCity; CompanyInformation.City) { }
            column(CompanyInformationPhoneNo; CompanyInformation."Phone No.") { }
            column(CompanyInformationHome; CompanyInformation."Home Page") { }
            column(CompanyInformationMail; CompanyInformation."E-Mail") { }
            column(CompanyInformationVATNo; CompanyInformation."VAT Registration No.") { }
            column(CompanyCountryName; CompanyCountryName) { }
            column(Posting_Date; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Document_Date; "Document Date") { }
            column(PaymentTermsDes; PaymentTermsDes) { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(LocationName; LocationName) { }
            column(LocationCodeHeader; "Location Code") { }
            column(ShipmentDescription; ShipmentDescription) { }
            column(Payment_Method_Code; "Payment Method Code") { }
            column(BlanketOrderNo; BlanketOrderNo) { }
            column(Prepayment__; "Prepayment %") { }
            column(Buy_from_Contact; ContactName) { }
            column(ETD; ETD) { }
            column(Transit_Time; "Transit Time") { }
            column(ETA_Transit_Port; "ETA Transit Port") { }
            column(Lead_Time_Calculation; "Lead Time Calculation") { }
            column(Currency_Code; CurrencyCode) { }
            column(Email; Email) { }
            column(PhoneNo; PhoneNo) { }
            column(MobileNo; MobileNo) { }
            column(FaxNo; FaxNo) { }
            column(Deposit; Deposit) { }
            column(Expected_Receipt_Date; "Expected Receipt Date") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_County; "Ship-to County") { }
            column(Assigned_User_ID1; "Assigned User ID") { }
            column(Assigned_User_ID; "Purchaser Code") { }
            column(Incoterm; Incoterm) { }
            column(Freight_Forwarder; "Freight Forwarder") { }
            column(PurchaserName; PurchaserName) { }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Type; Type) { }
                column(No1; "No.") { }
                column(Description; Description) { }
                column(Description_2; "Description 2") { }
                column(CombinedDescription; "Description" + "Description 2") { }
                column(Location_Code; "Location Code") { }
                column(Direct_Unit_Cost; "Direct Unit Cost") { }
                column(Quantity; Quantity) { }
                column(Line_Amount; "Line Amount") { }
                column(Inv__Discount_Amount; "Inv. Discount Amount") { }
                column(Amount; Amount) { }
                column(VAT__; "VAT %") { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(Line_Discount__; "Line Discount %") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Price_Per_Pound; "Price Per Pound") { }
                column(PricePerKG; PricePerKG) { }
                column(LBConversionQty; LBConversionQty) { }
                column(KGConversionQty; KGConversionQty) { }
                column(Prepayment_Amount; "Prepmt. Line Amount") { }
                column(TotalLBWeight; TotalLBWeight) { }
                column(TotalKGWeight; TotalKGWeight) { }
                trigger OnAfterGetRecord()
                begin
                    Clear(LBConversionQty);
                    Clear(KGConversionQty);
                    Clear(PricePerKG);
                    Clear(TotalLBWeight);
                    Clear(TotalKGWeight);
                    ItemUOM.Reset();
                    ItemUOM.SetRange(ItemUOM."Item No.", "Purchase Line"."No.");
                    ItemUOM.SetFilter(Code, 'LB');
                    if ItemUOM.FindFirst() then begin
                        LBConversionQty := ItemUOM."Qty. per Unit of Measure";
                        TotalLBWeight := LBConversionQty * "Purchase Line".Quantity;
                    end;
                    ItemUOM.Reset();
                    ItemUOM.SetRange(ItemUOM."Item No.", "Purchase Line"."No.");
                    ItemUOM.SetFilter(Code, 'KG');
                    if ItemUOM.FindFirst() then begin
                        KGConversionQty := ItemUOM.Weight;
                        TotalKGWeight := KGConversionQty * "Purchase Line".Quantity;
                        PricePerKG := ("Purchase Line"."Line Amount") / (KGConversionQty * "Purchase Line".Quantity);
                    end;
                    if "Purchase Line"."Blanket Order No." <> '' then
                        BlanketOrderNo := "Purchase Line"."Blanket Order No.";
                end;
            }
            dataitem("Purch. Comment Line"; "Purch. Comment Line")
            {
                DataItemLink = "No." = field("No.");
                column(Comment; Comment) { }
            }

            trigger OnAfterGetRecord()
            begin

                CountryRegion.Reset();
                CountryRegion.SetRange(Code, CompanyInformation."Country/Region Code");
                If CountryRegion.FindFirst() then
                    CompanyCountryName := CountryRegion.Name;

                PaymentTerms.Reset();
                PaymentTerms.SetRange(Code, "Payment Terms Code");
                if PaymentTerms.FindFirst() then
                    PaymentTermsDes := PaymentTerms.Description;

                Location.Reset();
                Location.SetRange(Code, "Location Code");
                if Location.FindFirst() then
                    LocationName := Location.Name;

                ShipmentMethode.Reset();
                ShipmentMethode.SetRange(Code, "Shipment Method Code");
                if ShipmentMethode.FindFirst() then
                    ShipmentDescription := ShipmentMethode.Description;

                if "Purchase Header"."Buy-from Contact No." <> '' then begin
                    if Contacts.Get("Purchase Header"."Buy-from Contact No.") then begin
                        ContactName := Contacts.Name;
                        PhoneNo := Contacts."Phone No.";
                        Email := Contacts."E-Mail";
                        MobileNo := Contacts."Mobile Phone No.";
                        FaxNo := Contacts."Fax No.";
                    end else begin
                        vendor.Reset();
                        vendor.SetRange("No.", "Purchase Header"."Buy-from Vendor No.");
                        if vendor.FindFirst() then begin
                            ContactName := vendor.Name;
                            Email := vendor."E-Mail";
                            MobileNo := vendor."Mobile Phone No.";
                            PhoneNo := vendor."Phone No.";
                            FaxNo := vendor."Fax No.";
                        end;
                    end;
                end;
                GenledSetup.Get();
                if "Purchase Header"."Currency Code" <> '' then
                    CurrencyCode := "Purchase Header"."Currency Code"
                else
                    CurrencyCode := GenledSetup."LCY Code";
                if Purchaser.Get("Purchase Header"."Purchaser Code") then
                    PurchaserName := Purchaser.Name;
            end;
        }
    }
    trigger OnPreReport()
    begin
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
    end;

    Var
        CompanyInformation: Record "Company Information";
        CountryRegion: Record "Country/Region";
        PaymentTerms: Record "Payment Terms";
        Location: Record Location;
        ShipmentMethode: Record "Shipment Method";
        ItemUOM: Record "Item Unit of Measure";
        ShipmentDescription: Text[100];
        CompanyCountryName: Text;
        PaymentTermsDes: Text;
        LocationName: Text;
        BlanketOrderNo: Code[20];
        Contacts: Record Contact;
        vendor: Record Vendor;
        Purchaser: Record "Salesperson/Purchaser";
        Email: Text[80];
        MobileNo: Text[30];
        PhoneNo: Text[30];
        FaxNo: Text[30];
        LBConversionQty: Decimal;
        KGConversionQty: Decimal;
        PricePerKG: Decimal;
        CurrencyCode: Code[20];
        GenledSetup: Record "General Ledger Setup";
        ContactName: Text[100];
        TotalLBWeight: Decimal;
        TotalKGWeight: Decimal;
        PurchaserName: Text[100];
}
