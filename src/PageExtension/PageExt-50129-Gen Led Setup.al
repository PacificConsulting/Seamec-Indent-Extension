pageextension 50129 "Gen. Led Setup" extends "General Ledger Setup"
{
    layout
    {
        addafter("Tax Information")
        {
            group("RFQ Setup")
            {
                Caption = 'RFQ Setup';
                Visible = true;
                field("RFQ URL"; Rec."RFQ URL")
                {
                    ApplicationArea = all;
                }
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