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
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}