pageextension 50131 "Avail Item Led Entry Ext" extends "Available - Item Ledg. Entries"
{
    layout
    {
        addafter("Lot No.")
        {
            field("Variant Code"; Rec."Variant Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the variant of the item on the line.';
            }
            field("Lot Sepcific Cost"; Rec."Lot Sepcific Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Sepcific Cost field.';
            }
            field("Indirect Cost"; Rec."Indirect Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Lot Sepcific Cost field.';
                Visible = false;
            }
            field("IndirectCost"; IndirectCost)
            {
                ApplicationArea = All;
                Caption = 'Indirect Cost';
                ToolTip = 'Specifies the value of the Lot Sepcific Cost field.';
            }
            field("Transport Cost"; Rec."Transport Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Transport Cost field.';
            }
            field(ILELandedCost; ILELandedCost)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Landed Cost field.';
                Caption = 'Landed Cost';
            }
        }
    }
    var
        ILELandedCost: Decimal;
        IndirectCost: Decimal;

    trigger OnOpenPage()
    begin
        LandedCost();
    end;

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
        if Item.Get(Rec."Item No.") then begin
            IndirectCost := Item."Indirect Cost Amount";
        end;
        Rec.CalcFields("Lot Sepcific Cost", "Indirect Cost", "Transport Cost");
        ILELandedCost := Rec."Lot Sepcific Cost" + IndirectCost + Rec."Transport Cost";
    end;
}
