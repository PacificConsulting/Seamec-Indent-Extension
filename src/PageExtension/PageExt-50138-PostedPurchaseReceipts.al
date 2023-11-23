pageextension 50138 PostedPurchaseReceiptsExt extends "Posted Purchase Receipts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("GRN Report")
            {
                Image = Report;
                //Promoted = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PRH: record "Purch. Rcpt. Header";
                begin
                    PRH.Reset();
                    PRH.SetRange("No.", Rec."No.");
                    if PRH.FindFirst() then
                        Report.RunModal(50099, true, false, PRH);
                end;

            }

        }

    }

    var
        myInt: Integer;
}