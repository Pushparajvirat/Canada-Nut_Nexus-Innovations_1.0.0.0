pageextension 50118 "Lot No Information Ext" extends "Lot No. Information Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Expiration Date field.';
            }
            field("New Expiration Date"; Rec."New Expiration Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the New Expiration Date field.';
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action("Update Exchange Rate")
            {
                Caption = 'Update Exchange Rate';
                ApplicationArea = all;
                Image = UpdateDescription;
                trigger OnAction()
                Var
                    ItemExchange: Codeunit "Item Charge Assigment Codeunit";
                    confirm: Dialog;
                begin
                    if confirm('Do you want to change the Expiration Date for %1', false, Rec."Lot No.") then begin
                        ItemExchange.UpdateExpirationDate(Rec);
                        Clear(Rec."New Expiration Date");
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }
}
