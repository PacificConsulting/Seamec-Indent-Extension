pageextension 50135 OrderProccessorExt extends "Order Processor Role Center"
{
    layout
    {
        addafter(Control1901851508)
        {
            part(AdvancePayment; "Advance Payment")
            {
                ApplicationArea = Basic, Suite;
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