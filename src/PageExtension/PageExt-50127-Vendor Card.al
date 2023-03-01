pageextension 50127 VendorCardExte extends "Vendor Card"
{
    layout
    {
        addafter("Address 2")
        {
            field(Password; Rec.Password)
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