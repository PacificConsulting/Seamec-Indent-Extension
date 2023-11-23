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
            // field("Approval Administrator"; Rec."Approval Administrator")
            // {
            //     ApplicationArea = all;
            // }  //PCPL-25/050723 already defined in semaec upgration project 
            field("First Indent Approver"; Rec."First Indent Approver")
            {
                ApplicationArea = All;
            }
            field("Second Indent Approver"; Rec."Second Indent Approver")
            {
                ApplicationArea = All;
            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Control1)
        {
            field("Modify Po"; Rec."Modify Po")
            {
                ApplicationArea = all;
            }
            field("Delete Requisition"; Rec."Delete Requisition")
            {
                ApplicationArea = all;
            }
        }
        addafter("Location Code")
        {
            field("Modify Indent"; Rec."Modify Indent")
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
    }
}