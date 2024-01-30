page 50219 "Modify Indent List"
{
    PageType = List;
    Caption = 'Update Indent List';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 50022;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}