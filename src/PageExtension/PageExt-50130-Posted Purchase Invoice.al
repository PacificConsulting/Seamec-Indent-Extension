pageextension 50130 PostedPurchInvExt extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Document Date")
        {
            field("RFQ Indent No."; Rec."RFQ Indent No.")
            {
                ApplicationArea = All;
                Editable = false;
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