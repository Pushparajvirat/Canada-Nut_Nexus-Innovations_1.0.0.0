page 50101 "Canada Nut PO Receive API"
{
    ODataKeyFields = SystemId;
    SourceTable = "Purchase Header";
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'Nexus';
    APIGroup = 'workflows';
    EntityCaption = 'PurchaseOrder';
    EntitySetCaption = 'PurchaseOrder';
    EntityName = 'purchaseOrder';
    EntitySetName = 'purchaseOrder';
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(id; rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field("no"; rec."No.")
                {
                    ApplicationArea = All;
                }
                field(createdByName; Rec."Created By Name")
                {
                    Caption = 'CreatedByName';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        rec.SetRange("Document Type", rec."Document Type"::Order);
    end;
    local procedure GetOrder(var PurchaseHeader: Record "Purchase Header")
    begin
        if not PurchaseHeader.GetBySystemId(rec.SystemId)then Error('The order cannot be found.');
    end;
    local procedure Post(var PurchaseHeader: Record "Purchase Header")
    var
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
    //OrderNo: Code[20];
    //OrderNoSeries: Code[20];
    begin
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader);
        //OrderNo := PurchaseHeader."No.";
        //OrderNoSeries := PurchaseHeader."No. Series";
        PurchaseHeader.Receive:=true;
        PurchaseHeader.Invoice:=false;
        PurchaseHeader.SendToPosting(Codeunit::"Purch.-Post");
        Commit();
    end;
    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; OrderId: Guid)
    var
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Canada Nut PO Receive API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), OrderId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;
    [ServiceEnabled]
    [Scope('Cloud')]
    procedure Receive(var ActionContext: WebServiceActionContext)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        GetOrder(PurchaseHeader);
        Post(PurchaseHeader);
        SetActionResponse(ActionContext, PurchaseHeader.SystemId);
    end;
}
