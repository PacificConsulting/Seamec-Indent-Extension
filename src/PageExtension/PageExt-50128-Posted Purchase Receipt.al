pageextension 50128 Posted_Purchase_Reciept_Ext extends "Posted Purchase Receipt"
{
    layout
    {
        addafter("Document Date")
        {
            field("RFQ Indent No."; Rec."RFQ Indent No.")
            {
                ApplicationArea = All;
                Editable = False;
            }
        }
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
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}