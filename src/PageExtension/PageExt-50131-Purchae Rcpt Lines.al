pageextension 50131 PurchRcptLinesExt extends "Purch. Receipt Lines"
{
    layout
    {
        addafter("Unit Cost")
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