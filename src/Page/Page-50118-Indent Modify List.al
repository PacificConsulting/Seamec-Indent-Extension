page 50118 "indent Modify List"
{
    //pCPL-064 16oct2023
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Indent Header";
    // Editable = false;


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
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Indent Description"; Rec."Indent Description")
                {
                    ApplicationArea = all;
                    Editable = IsPermissionToView;
                }
                field("Indent Due Date"; Rec."Indent Due Date")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Approver ID"; Rec."Approver ID")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Material category"; Rec."Material category")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("Po Created"; Rec."Po Created")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        /*  if UserSetup.get(UserId) then begin  //pcpl-064 16oct2023
             if UserSetup."Modify Indent" = true then
                 CurrPage.Editable(true)
             else
                 CurrPage.Editable(false);

         end; */
        //pcpl-064 16oct2023
    end;

    trigger OnOpenPage()
    begin
        /* if UserSetup.get(UserId) then begin  //pcpl-064 16oct2023
            if UserSetup."Modify Indent" = true then
                CurrPage.Editable(true)
            else
                CurrPage.Editable(false);
        end; */
        //pcpl-064 16oct2023
        IsPermissionToView := false;
        IsPermissionToView := IsHavePermissionToView();
    end;

    var
        UserSetup: record "User Setup";
        IsPermissionToView: Boolean;
    //pcpl-064 16oct2023

    //pcpl-064 <<16oct2023
    local procedure IsHavePermissionToView(): Boolean
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Modify Indent" then
                exit(true)
            else
                exit(false);
        end else begin
            exit(true);
        end;
    end;
    //pcpl-064 >>16oct2023

}