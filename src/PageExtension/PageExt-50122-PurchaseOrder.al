pageextension 50122 Purchase_order_Indent extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
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
            action("Purchase Order")
            {
                Promoted = true;
                Image = Report;
                ApplicationArea = all;
                trigger OnAction()

                begin
                    PH.Reset();
                    PH.SetRange("No.", PH."No.");
                    Report.RunModal(50097, true, false, PH);
                end;

            }
        }
    }

    var
        PHEader: Record 38;
        PH: Record "Purchase Header";
}