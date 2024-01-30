pageextension 50139 PO_Archi_list_ext extends "Purchase Order Archives"
{
    layout
    {
        addafter("Archived By")
        {
            field("PO Cancelled"; Rec."PO Cancelled")
            {
                ApplicationArea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}