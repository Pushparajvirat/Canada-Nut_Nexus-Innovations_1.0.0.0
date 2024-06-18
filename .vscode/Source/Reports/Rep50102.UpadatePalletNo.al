report 50102 "Upadate Pallet No."
{
    ApplicationArea = All;
    Caption = 'Upadate Pallet No.';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    Permissions = tabledata "Warehouse Entry" = RIMD;
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(DocumentNo; DocumentNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Entry No.';
                    }
                    field(PaletNo; PaletNo)
                    {
                        ApplicationArea = all;
                        Caption = 'Pallet No.';
                    }
                }
            }
        }
    }
    trigger OnPostReport()
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        WarehouseEntry.Reset();
        WarehouseEntry.SetRange("Entry No.", DocumentNo);
        if WarehouseEntry.FindSet() then begin
            repeat
                WarehouseEntry."Pallet No." := PaletNo;
                WarehouseEntry.Modify();
            until WarehouseEntry.Next() = 0;
        end;
    end;

    var
        DocumentNo: Integer;
        PaletNo: Code[20];
}
