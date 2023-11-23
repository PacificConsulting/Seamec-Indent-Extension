pageextension 50136 CommentSheetExt extends "Comment Sheet"
{
    layout
    {
        modify(Comment)
        {
            Visible = false;
        }
        addafter(Date)
        {
            field("Comment New"; Rec."Comment New")
            {
                ApplicationArea = All;
                Caption = 'Comment';
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