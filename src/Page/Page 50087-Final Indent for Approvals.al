page 50087 "Final Indent for Approvals"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    CardPageId = 50088;
    Editable = false;
    SourceTableView = where(Status = filter('First Approval'));
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                    //  OptionCaption = '" ,Project,Maintenance,Production,Quality Control,Research and Devolopment,Electrical,Instrument,Civil>"';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Release User ID"; Rec."Release User ID")
                {
                    ApplicationArea = all;
                }
                field("Material category"; Rec."Material category")
                {
                    ApplicationArea = all;
                }
                // field("Closed By"; Rec."Closed By")
                // {
                //     ApplicationArea = all;
                // }
                // field("Closed Date"; Rec."Closed Date")
                // {
                //     ApplicationArea = all;
                // }
            }
        }
    }

    trigger OnOpenPage()
    var
        RecUser: Record 91;
        TmpLocCode: Code[1024];
    begin
        UserSetup.GET(UserId);
        If UserSetup."Second Indent Approver" = false then
            Error('You do not have permission,Please contact your adminstrator');
        //PCPL-25/100723
        RecUser.RESET;
        RecUser.SETRANGE(RecUser."User ID", USERID);
        IF RecUser.FINDFIRST THEN BEGIN
            TmpLocCode := RecUser."Location Code";
        END;
        IF TmpLocCode <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETFILTER("Location Code", TmpLocCode);
            Rec.FILTERGROUP(0);
        END;
        //PCPL-25/100723
    end;



    var
        UserSetup: Record "User Setup";
        ShowBoo: Boolean;
}