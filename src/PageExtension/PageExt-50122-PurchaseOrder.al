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

    }

    actions
    {
        //PCPL-25/080823
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                PL: Record "Purchase Line";
            begin
                Rec.TestField("Location Code");
                PL.Reset();
                PL.SetRange("Document No.", Rec."No.");
                if PL.FindSet() then
                    repeat
                        PL.TestField("Location Code");
                    until PL.Next() = 0;
            end;
        }
        //PCPL-25/080823

        addafter("Archive Document")
        {

            action("Get Indent Line")
            {
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedCategory = Process;


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
                PromotedCategory = Report;
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