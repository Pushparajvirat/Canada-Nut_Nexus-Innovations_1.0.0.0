page 50104 "Canada Nut Purchase Line API"
{
    ODataKeyFields = SystemId;
    ModifyAllowed = true;
    Extensible = false;
    APIGroup = 'workflows';
    APIPublisher = 'Nexus';
    APIVersion = 'v2.0';
    Caption = 'purchaseLine';
    DelayedInsert = true;
    EntityCaption = 'purchaseLine';
    EntitySetCaption = 'purchaseLine';
    EntityName = 'purchaseLine';
    EntitySetName = 'purchaseLine';
    PageType = API;
    SourceTable = "purchase Line";

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
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
                field(receiptNo; Rec."Receipt No.")
                {
                    Caption = 'Receipt No.';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
            }
        }
    }
}
