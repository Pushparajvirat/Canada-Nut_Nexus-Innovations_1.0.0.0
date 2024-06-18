tableextension 50104 "Item Ext" extends Item
{
    fields
    {
        field(50100; "LB Conversion"; Boolean)
        {
            Caption = 'LB/KG Conversion';
            DataClassification = ToBeClassified;
        }
        field(50101; "Weight in LB"; Decimal)
        {
            Caption = 'Weight in LB';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Lot Algorithm Code"; Code[20])
        {
            Caption = 'Lot Algorithm Code';
            DataClassification = ToBeClassified;
        }
        field(50103; "Indirect Cost Amount"; Decimal)
        {
            Caption = 'Indirect Cost Amount';
            DataClassification = ToBeClassified;
        }
        field(50104; "In Transit Qty."; Decimal)
        {
            Caption = 'In Transit Purchase Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("ETD Date" = filter('..T'), "Document Type" = const(Order), "No." = field("No.")));
        }
        field(50105; "In Process Qty."; Decimal)
        {
            Caption = 'In Process Purchase Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line".Quantity where("ETD Date" = filter('1D+T..'), "Document Type" = const(Order), "No." = field("No.")));
        }
        field(50106; "Purchase Contract Var"; Decimal)
        {
            Caption = 'Purchase Contract Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Purchase Line"."Balance Qty." where("Document Type" = const("Blanket Order"), "No." = field("No.")));
        }
        field(50107; "In Transit Sales Qty."; Decimal)
        {
            Caption = 'In Transit Sales Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where("ETD Date" = filter('..T'), "Document Type" = const(Order), "No." = field("No.")));
        }
        field(50108; "In Process Sales Qty."; Decimal)
        {
            Caption = 'In Process Sales Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where("ETD Date" = filter('1D+T..'), "Document Type" = const(Order), "No." = field("No.")));
        }
        field(50109; "Sales Contract Var"; Decimal)
        {
            Caption = 'Sales Contract Qty.';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Balance Qty." where("Document Type" = const("Blanket Order"), "No." = field("No.")));
        }
        field(50110; "Sales Order Qty. Without Cont."; Decimal)
        {
            Caption = 'Sales Order Qty. Without Contract';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line".Quantity where("Document Type" = const(Order), "Blanket Order No." = filter(''), "No." = field("No.")));
        }
        field(50111; "Sales Budget"; Decimal)
        {
            Caption = 'Sales Budget';
            DataClassification = ToBeClassified;
        }
        field(50112; "Avail Replacement Cost"; Boolean)
        {
            Caption = 'Avail Replacement Cost';
            DataClassification = ToBeClassified;
        }
        field(50113; "Replacement Cost"; Decimal)
        {
            Caption = 'Replacement Cost';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50114; "Qty. By Pallet"; Decimal)
        {
            Caption = 'Qty. By Pallet';
            DataClassification = ToBeClassified;
        }
        field(50115; "Inventory SUOM"; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry"."Net Weight" WHERE("Item No." = FIELD("No."),
                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                  "Location Code" = FIELD("Location Filter"),
                                                                  "Drop Shipment" = FIELD("Drop Shipment Filter"),
                                                                  "Variant Code" = FIELD("Variant Filter"),
                                                                  "Lot No." = FIELD("Lot No. Filter"),
                                                                  "Serial No." = FIELD("Serial No. Filter"),
                                                                  "Unit of Measure Code" = FIELD("Unit of Measure Filter"),
                                                                  "Package No." = FIELD("Package No. Filter")));
            Caption = 'Inventory SUOM';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
