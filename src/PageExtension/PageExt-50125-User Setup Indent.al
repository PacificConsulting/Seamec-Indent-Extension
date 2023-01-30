pageextension 50125 User_Setup_Indent extends "User Setup" //OriginalId
{
    layout
    {
        addafter("User ID")
        {
            field("Indent Approver"; Rec."Indent Approver")
            {
                ApplicationArea = all;

            }
            field("Indent Releaser"; Rec."Indent Releaser")
            {
                ApplicationArea = all;
            }
            field(Substitute; Rec.Substitute)
            {
                ApplicationArea = all;
            }
            field("Approver ID"; Rec."Approver ID")
            {
                ApplicationArea = all;
            }
            field("Approval Administrator"; Rec."Approval Administrator")
            {
                ApplicationArea = all;
            }
            field("First Indent Approver"; Rec."First Indent Approver")
            {
                ApplicationArea = All;
            }
            field("Second Indent Approver"; Rec."Second Indent Approver")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}