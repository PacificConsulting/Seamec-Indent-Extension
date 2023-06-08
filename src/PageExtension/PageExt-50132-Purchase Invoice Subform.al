pageextension 50132 PurchInvSubformExt extends "Posted Purch. Invoice Subform"
{
    layout
    {
        addafter("Unit Cost (LCY)")
        {
            field("RFQ Remarks"; Rec."RFQ Remarks")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}