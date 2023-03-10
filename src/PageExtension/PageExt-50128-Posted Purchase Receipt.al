pageextension 50128 Posted_Purchase_Reciept_Ext extends "Posted Purchase Receipt"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Print")
        {
            action("Goods Received Note")
            {
                Image = Process;
                Promoted = true;
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
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}