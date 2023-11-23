page 50065 "Indent Header-List"
{
    // version RSPL/INDENT/V3/001
    Caption = 'Requisition List';
    CardPageID = "Purchase Indent";
    PageType = List;
    SourceTable = 50022;
    SourceTableView = SORTING("No.", "Entry Type")
                      WHERE(Status = FILTER(<> Closed), "Po Created" = filter(false));
    ApplicationArea = all;
    UsageCategory = Lists;
    DeleteAllowed = true;           //PCPL-25/080823

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
                field("Indent Description"; Rec."Indent Description")
                {
                    ApplicationArea = All;
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

    actions
    {
    }

    trigger OnOpenPage();
    var
        RecUser: Record 91;
        TmpLocCode: Code[100];
    begin
        CurrPage.Update();
        //PCPL-25
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
        //PCPL-25
    end;

    //PCPL-25/080823
    trigger OnDeleteRecord(): Boolean
    var
        UserSet: Record "User Setup";
        PL: Record "Purchase Line";
        ReqArchiH: Record "Requisition Archive Header";
        ReqArchiveLine: Record "Requisition Archive Lines";
        IndentLine: Record "Indent Line";
    begin
        //IF CONFIRM('Do you want to delete this requision') THEN BEGIN
        if UserSet.Get(UserId) then;
        if UserSet."Delete Requisition" = false then begin
            Error('You do not have permission to delete this requisition.');
        end;
        PL.Reset();
        PL.SetRange("Indent No.", Rec."No.");
        if PL.FindFirst() then begin
            Error('You can not delete this requisition, Purchase order is already created');
        end;
        ReqArchiH.Reset();
        ReqArchiH.SetRange("No.", Rec."No.");
        if not ReqArchiH.FindFirst() then begin
            ReqArchiH.Init();
            ReqArchiH.TransferFields(Rec);
            ReqArchiH."Deleted By" := UserId;
            ReqArchiH."Deleted Date" := Today;
            ReqArchiH.Status := ReqArchiH.Status::Cancel;
            ReqArchiH.Insert();
        end;

        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        if IndentLine.FindSet() then
            repeat
                ReqArchiveLine.Reset();
                ReqArchiveLine.SetRange("Document No.", IndentLine."Document No.");
                ReqArchiveLine.SetRange("Line No.", IndentLine."Line No.");
                if not ReqArchiveLine.FindFirst() then begin
                    ReqArchiveLine.Init();
                    ReqArchiveLine.TransferFields(IndentLine);
                    ReqArchiveLine.Insert();
                end;
            until IndentLine.Next() = 0;
        Commit();
        CurrPage.Update();
    end;
    //end;
    //PCPL-25/080823

    trigger OnModifyRecord(): Boolean
    var
        myInt: Integer;
    begin
        Rec.TestField(Status, Rec.Status::Open);
    end;
}

