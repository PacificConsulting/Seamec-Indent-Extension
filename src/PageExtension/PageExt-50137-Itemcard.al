pageextension 50137 ItemCardindent extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
        /* addlast(Item)
         {
             field("Item Details"; Rec."Item Details")
             {
                 ApplicationArea = all;
             }
         } */
    }

    actions
    {
        // Add changes to page actions here
    }
    //PCPL-25/180723
    trigger OnAfterGetRecord()
    var
        CommLine: Record "Comment Line";
        TextComment: Text;
    begin
        Clear(TextComment);
        CommLine.Reset();
        CommLine.SetRange("Table Name", CommLine."Table Name"::Item);
        CommLine.SetRange("No.", Rec."No.");
        if CommLine.FindSet() then
            repeat
                if TextComment = '' then
                    TextComment := CommLine."Comment New"
                else
                    TextComment := TextComment + ' ' + CommLine."Comment New";
            until CommLine.Next() = 0;
        Rec."Item Details" := PadStr(TextComment, 250);
        Rec.Modify();
    end;
    //PCPL-25/180723

    var
        myInt: Integer;
}