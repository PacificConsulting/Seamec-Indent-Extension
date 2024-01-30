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
                field("Quotation Received Mail"; Rec."Quotation Received Mail")
                {
                    ApplicationArea = All;
                }
                field("RFQ CC Mail"; Rec."RFQ CC Mail")
                {
                    ApplicationArea = All;
                }
                field("RFQ CC_2 Mail"; Rec."RFQ CC_2 Mail")
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