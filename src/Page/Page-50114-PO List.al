page 50114 "Purchase List modify"
{
    Caption = 'Modify Po';
    Editable = true;
    PageType = List;
    InsertAllowed = false;
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    UsageCategory = Lists;
    DeleteAllowed = false;      //PCPL-25/100723


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Show Vessel GRN"; Rec."Show Vessel GRN")
                {
                    ApplicationArea = all;
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

    trigger OnOpenPage()
    var
        Userset: Record "User Setup";
    begin
        if Userset.Get(UserId) then;
        if Userset."Modify Po" = false then
            Error('you do not have permission to open this po');
    end;

    var
        myInt: Integer;
}