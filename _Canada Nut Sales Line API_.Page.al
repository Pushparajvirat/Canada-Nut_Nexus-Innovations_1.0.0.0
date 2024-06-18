page 50103 "Canada Nut Sales Line API"
{
    ODataKeyFields = SystemId;
    ModifyAllowed = true;
    Extensible = false;
    APIGroup = 'workflows';
    APIPublisher = 'Nexus';
    APIVersion = 'v2.0';
    Caption = 'salesLine';
    DelayedInsert = true;
    EntityCaption = 'salesLine';
    EntitySetCaption = 'salesLine';
    EntityName = 'salesLine';
    EntitySetName = 'salesLine';
    PageType = API;
    SourceTable = "Sales Line";

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
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(jobNo; Rec."Job No.")
                {
                    Caption = 'Job No.';
                }
                field(jobTaskNo; Rec."Job Task No.")
                {
                    Caption = 'Job Task No.';
                }
            }
        }
    }
}
