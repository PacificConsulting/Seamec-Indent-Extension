pageextension 50122 Purchase_order_Indent extends "Purchase Order"
{
    layout
    {
        addafter("Buy-from City")
        {
            field(Clauses; Rec.Clauses)
            {
                ApplicationArea = All;
            }
        }
        addafter("Posting Date")
        {
            field("RFQ Indent No."; Rec."RFQ Indent No.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter("Remove From Job Queue")
        {
            action("Get Indent Line")
            {
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    PHEader.RESET;
                    PHEader.SETRANGE(PHEader."Document Type", PHEader."Document Type"::Order);
                    PHEader.SETRANGE("No.", Rec."No.");
                    IF PHEader.FINDFIRST THEN BEGIN
                        CurrPage.PurchLines.PAGE.GetIndentLines;
                    END;
                end;
            }

        }
        addafter("&Print")
        {
            action("Purchase Order Report")
            {
                Promoted = true;
                Image = Print;
                ApplicationArea = all;
                trigger OnAction()

                begin
                    Rec.TestField(Clauses);
                    PH.Reset();
                    PH.SetRange("No.", Rec."No.");
                    if PH.FindFirst() then
                        Report.RunModal(50097, true, false, PH);
                end;

            }
        }
    }

    var
        PHEader: Record 38;
        PH: Record "Purchase Header";
}