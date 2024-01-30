pageextension 50126 PurchPayablesSetupExt extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Order Nos.")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = all;
            }
            field("Indent No.1"; Rec."Indent No.1")
            {
                ApplicationArea = all;
            }
            field("Gross Period Date"; Rec."Gross Period Date")
            {
                ApplicationArea = All;
            }
            field("Purchase Indent Deletion Date"; Rec."Purchase Indent Deletion Date")
            {
                ApplicationArea = all;
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