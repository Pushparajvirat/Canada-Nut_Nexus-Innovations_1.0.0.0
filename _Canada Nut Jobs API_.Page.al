page 50102 "Canada Nut Jobs API"
{
    APIGroup = 'workflows';
    APIPublisher = 'Nexus';
    APIVersion = 'v2.0';
    Caption = 'jobsAPI';
    DelayedInsert = true;
    EntityCaption = 'Jobs';
    EntitySetCaption = 'Jobs';
    EntityName = 'jobs';
    EntitySetName = 'jobs';
    PageType = API;
    SourceTable = Job;
    ODataKeyFields = SystemId;
    ModifyAllowed = true;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(billToCustomerNo; Rec."Bill-to Customer No.")
                {
                    Caption = 'Bill-to Customer No.';
                }
                field(billToName; Rec."Bill-to Name")
                {
                    Caption = 'Bill-to Name';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(projectManager; Rec."Project Manager")
                {
                    Caption = 'Project Manager';
                }
            }
        }
    }
}
