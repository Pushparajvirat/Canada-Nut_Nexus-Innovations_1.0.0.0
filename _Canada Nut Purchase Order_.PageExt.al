pageextension 50102 "Canada Nut Purchase Order" extends "Purchase Order"
{
    layout
    {
        addafter(Status)
        {
            field("Created By Name"; Rec."Created By Name")
            {
                ApplicationArea = All;
                Caption = 'Created By Name';
                Editable = false;
                Visible = true;
            }
            field("Container Inspection"; Rec."Container Inspection")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Container Inspection field.';
            }
        }
        addafter("Invoice Details")
        {
            group("Container Details")
            {
                Caption = 'Container Details';
                field(SKID; Rec.SKID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SKID field.';
                }
                field("Container ID"; Rec."Container ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Container ID field.';
                }
                field("Shipping Line"; Rec."Shipping Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Shipping Line field.';
                }
                field(Incoterm; Rec.Incoterm)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Incoterm field.';
                }
                field(ETD; Rec.ETD)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETD field.';
                }
                field("Transit Time"; Rec."Transit Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transit Time field.';
                }
                field("Freight Forwarder"; Rec."Freight Forwarder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Freight Forwarder field.';
                }
                field(Carrier; Rec.Carrier)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Carrier field.';
                }
                field("Total Freight Cost"; Rec."Total Freight Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Total Freight Cost field.';
                }
                field("Transit Port"; Rec."Transit Port")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Transit Port field.';
                }
                field("ETA Transit Port"; Rec."ETA Transit Port")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA Transit Port field.';
                }
                field("ETA POD"; Rec."ETA POD")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ETA POD field.';
                }
                field("Final Destination"; Rec."Final Destination")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Final Destination field.';
                }
                field("Delivery Expected Date"; Rec."Delivery Expected Date")
                {
                    Caption = 'ETA To Laval';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery Expected Date field.';
                }
                field(Deposit; Rec.Deposit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Deposit field.';
                }
                field("Confirmation Payment"; Rec."Confirmation Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmation Payment field.';
                }
                field("OBL Issued Via Courier Service"; Rec."OBL Issued Via Courier Service")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the OBL Issued Via Courier Service field.';
                }
                field("Steam Ship Released"; Rec."Steam Ship Released")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Steam Ship Released field.';
                }
                field("Custom Released"; Rec."Custom Released")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Custom Released field.';
                }
                field("LFD Pickup"; Rec."LFD Pickup")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LFD Pickup field.';
                }
                field("LFD Return"; Rec."LFD Return")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LFD Return field.';
                }
                field(EIR; Rec.EIR)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the EIR field.';
                }
                field("Return place"; Rec."Return place")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Return place field.';
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Exchange Rate field.';
                }
            }
        }

    }
}
