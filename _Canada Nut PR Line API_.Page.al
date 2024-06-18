page 50105 "Canada Nut PR Line API"
{
    ODataKeyFields = SystemId;
    ModifyAllowed = true;
    Extensible = false;
    APIGroup = 'workflows';
    APIPublisher = 'Nexus';
    APIVersion = 'v2.0';
    Caption = 'purchaseReceiptLine';
    DelayedInsert = true;
    EntityCaption = 'purchaseReceiptLine';
    EntitySetCaption = 'purchaseReceiptLine';
    EntityName = 'purchaseReceiptLine';
    EntitySetName = 'purchaseReceiptLine';
    PageType = API;
    SourceTable = "Purch. Rcpt. Line";

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
                field(orderNo; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
            }
        }
    }
}
