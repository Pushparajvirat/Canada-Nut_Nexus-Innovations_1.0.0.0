pageextension 50128 "Reservation Worksheet Ext" extends Reservation
{
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if SalesLineRec.FindFirst() then begin
            if (CloseAction In [CloseAction::LookupOK, CloseAction::OK]) then begin
                if Rec."Total Reserved Quantity" <> 0 then begin
                    ReservationCodeunit.UpdateSalesOrderCost(SalesLineRec);
                end else begin
                    SalesLineRec."Material Cost" := 0;
                    SalesLineRec."Freight Cost" := 0;
                    SalesLineRec."Landed Cost" := 0;
                    SalesLineRec.Modify();
                end;
            end;
        end;
    end;

    var
        SalesLineRec: Record "Sales Line";
        ReservationCodeunit: Codeunit "Reservation Codeunit";

    procedure Gettable(Var RecSalesLine: Record "Sales Line")
    begin
        SalesLineRec.Copy(RecSalesLine);
    end;
}
