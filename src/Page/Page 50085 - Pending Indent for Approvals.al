page 50085 "Pending Indent for Approvals"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Indent Header";
    CardPageId = 50086;
    Editable = false;
    SourceTableView = where(Status = filter('Pending For Approval'));

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
                    OptionCaption = '" ,Engineering,Raw Materials,Lab Equipment,Lab Chemicals,Packing Material,Safety,Production,Information Technology,Bldg. No1,Bldg No.2,Bldg No.3,QA,Warehouse,SRP,ETP & MEE,Utility,Formulation>"';
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
                field("Closed By"; Rec."Closed By")
                {
                    ApplicationArea = all;
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        UserSetup.Reset();
        UserSetup.SetRange("First Indent Approver", UserId);
        if UserSetup.FindFirst() then
            Rec.SetRange("Approver ID", UserSetup."User ID");
    end;

    var
        UserSetup: Record "User Setup";
}