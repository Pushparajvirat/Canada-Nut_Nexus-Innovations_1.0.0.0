page 50111 "Replacement Cost"
{
    ApplicationArea = All;
    Caption = 'Replacement Cost';
    PageType = List;
    SourceTable = "Replacement Cost1";
    UsageCategory = Lists;
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ToolTip = 'Specifies the value of the Starting Date field.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ToolTip = 'Specifies the value of the Unit Cost field.';
                }
                field("Replacement Cost"; Rec."Replacement Cost")
                {
                    ToolTip = 'Specifies the value of the Replacement Cost field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Replacement Cost")
            {
                Caption = 'Import Replacement Cost';
                Image = ImportExcel;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
    }
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';
        FileName: Text[100];
        SheetName: Text[100];

    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ImportExcelData()
    var
        ReplacementCost1: Record "Replacement Cost1";
        ReplacementCost: Record "Replacement Cost1";
        ReplacementCost2: Record "Replacement Cost1";
        Vendor: Record Vendor;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        Result: Boolean;
        StartingDate: Date;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            Evaluate(StartingDate, (GetValueAtCell(RowNo, 3)));
            ReplacementCost.Reset();
            ReplacementCost.SetRange("Item No.", GetValueAtCell(RowNo, 1));
            ReplacementCost.SetRange("Starting Date", StartingDate);
            if not ReplacementCost.FindFirst() then begin
                ReplacementCost1.Init();
                ReplacementCost1.Validate("Item No.", GetValueAtCell(RowNo, 1));
                ReplacementCost2.Reset();
                ReplacementCost2.SetRange("Item No.", GetValueAtCell(RowNo, 1));
                if ReplacementCost2.FindLast() then
                    LineNo := ReplacementCost2."Line No." + 10000
                else
                    LineNo := 10000;
                ReplacementCost1."Line No." := LineNo;
                Evaluate(ReplacementCost1."Starting Date", GetValueAtCell(RowNo, 3));
                Evaluate(ReplacementCost1."Replacement Cost", GetValueAtCell(RowNo, 5));
                ReplacementCost1.Insert(true);
            end else begin
                Evaluate(ReplacementCost1."Replacement Cost", GetValueAtCell(RowNo, 5));
                Result := ReplacementCost.modify();
            end;
        end;
        if Result then
            Message(ExcelImportSucess);
    end;

}
