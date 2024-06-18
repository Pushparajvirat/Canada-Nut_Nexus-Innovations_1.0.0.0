pageextension 50130 "Availa  Purchase Line Ext" extends "Available - Purchase Lines"
{
    layout
    {
        addafter(ReservedQuantity)
        {
            field("Lot No."; Rec."Lot No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot No. field.';
            }
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant of the item on the line.';
            }
            field("Unit Cost"; Rec."Direct Unit Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Cost field.';
                Caption = 'Lot Specific Cost';
            }
            field(IndirectCost; IndirectCost)
            {
                Caption = 'Indirect Cost';
                ApplicationArea = all;
            }
            field("Transport Cost"; Rec."Transport Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Cost field.';
            }
            field(PurLandedCost; PurLandedCost)
            {
                Caption = 'Landed Cost';
                ApplicationArea = all;
            }
        }
    }
    var
        PurLandedCost: Decimal;
        IndirectCost: Decimal;

    // trigger OnOpenPage()
    // begin
    //     LandedCost();
    // end;

    trigger OnAfterGetCurrRecord()
    begin
        LandedCost();
    end;

    trigger OnAfterGetRecord()
    begin
        LandedCost();
    end;

    local procedure LandedCost()
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."No.") then begin
            IndirectCost := Item."Indirect Cost Amount";
        end;
        Rec.CalcFields("Transport Cost");
        PurLandedCost := Rec."Direct Unit Cost" + IndirectCost + Rec."Transport Cost";
    end;
}
