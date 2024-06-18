page 50100 "Canada Nut User Setup API"
{
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'Nexus';
    APIGroup = 'workflows';
    EntityCaption = 'UserSetup';
    EntitySetCaption = 'UserSetup';
    EntityName = 'userSetup';
    EntitySetName = 'userSetup';
    ODataKeyFields = SystemId;
    SourceTable = "User Setup";
    ModifyAllowed = true;
    Extensible = false;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("userId"; rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("approverId"; rec."Approver ID")
                {
                    ApplicationArea = All;
                }
                field("salesLimit"; rec."Sales Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
                field("unlimitedSales"; rec."Unlimited Sales Approval")
                {
                    ApplicationArea = All;
                }
                field("purchaseLimit"; rec."Purchase Amount Approval Limit")
                {
                    ApplicationArea = All;
                }
                field("unilimitedPurchase"; rec."Unlimited Purchase Approval")
                {
                    ApplicationArea = All;
                }
                field("email"; rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("substitute"; rec."Substitute")
                {
                    ApplicationArea = All;
                }
                field(systemId; rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
