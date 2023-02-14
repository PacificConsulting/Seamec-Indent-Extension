page 50091 "RFQ Card"
{
    //--PCPL/0070/13Feb2023
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "RFQ Header";
    Editable = true;


    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = All;
                }
            }
            part(RFQLines; 50090)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("Document No.");
            }
        }
    }

    var
        myInt: Integer;
}