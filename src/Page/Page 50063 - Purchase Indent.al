page 50063
 "Purchase Indent"
{
    // version RSPL/INDENT/V3/001,PCPL-FA-1.0,PCPL-25/INCDoc

    // Name        Code        Description
    // Venkatesh   VK001       Introduce Release and Reopen Option
    Caption = 'Requisition Purchase Header';
    Editable = true;
    PageType = Card;
    SourceTable = 50022;
    SourceTableView = WHERE("Entry Type" = FILTER(Indent));
    DeleteAllowed = true; //PCPL-25/080823

    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                AssistEdit = true;
                ApplicationArea = All;

                trigger OnAssistEdit();
                begin


                    IF Rec.AssistEdit(xRec) THEN
                        CurrPage.UPDATE;
                end;
            }
            field("Indent Type"; Rec."Indent Type")
            {
                ApplicationArea = All;
            }
            field("Indent Description"; Rec."Indent Description")
            {
                ApplicationArea = all;
            }
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = all;
                // OptionCaption = '" ,Project,Maintenance,Production,Quality Control,Research and Devolopment,Electrical,Instrument,Civil,Stationary,Upgradation"';
            }
            field("Material category"; Rec."Material category")
            {
                ApplicationArea = all;
                Visible = False;
            }
            field("Location Code"; Rec."Location Code")
            {
                Editable = true;
                ApplicationArea = all;
            }
            field(Category; Rec.Category)
            {
                ApplicationArea = all;
            }
            field(Date; Rec.Date)
            {
                ApplicationArea = all;
                Editable = true;
            }
            field("Indent Due Date"; Rec."Indent Due Date")
            {
                ApplicationArea = all;
            }
            field("Job Maintenance No."; Rec."Job Maintenance No.")
            {
                ApplicationArea = all;
            }
            field("Type of Indent"; Rec."Type of Indent")
            {
                ApplicationArea = All;
            }

            field(Status; Rec.Status)
            {
                ApplicationArea = all;
            }
            field("Release User ID"; Rec."Release User ID")
            {
                ApplicationArea = all;
            }
            field(Comments; Rec.Comments)
            {
                ApplicationArea = all;
            }
            part(IndentLines; 50064)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
        //PCPL-25/170323
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50022),
                              "No." = FIELD("No.");
            }
        }
        //PCPL-25/170323

    }

    actions
    {
        area(navigation)
        {
            group("&Indent")
            {
                Caption = '&Indent';

                action("Re&open")
                {
                    Caption = 'Re&open';
                    Visible = false;
                    Image = ReOpen;
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        //VK001-Begin
                        IF USer.GET(USERID) THEN
                            IF USer."Indent Releaser" = TRUE THEN BEGIN
                                Rec.Status := rec.Status::Open;
                                CurrPage.IndentLines.PAGE.EDITABLE(TRUE);
                                Rec.MODIFY;
                            END ELSE
                                ERROR(Text001);


                        //VK001-End
                        IF Rec.Status = Rec.Status::Open THEN BEGIN
                            IndentLine.RESET;
                            IndentLine.SETRANGE(IndentLine."Document No.", Rec."No.");
                            IF IndentLine.FINDSET THEN
                                REPEAT
                                    IndentLine.Status := FALSE;
                                    IndentLine.MODIFY;
                                UNTIL IndentLine.NEXT = 0;
                        END;
                    end;
                }
                action("&Release")
                {
                    Caption = '&Release';
                    Visible = false;
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ApplicationArea = all;

                    trigger OnAction();
                    begin
                        //PCPL41_05032020_S
                        IndentLine1.RESET;
                        IndentLine1.SETRANGE("Document No.", Rec."No.");
                        IF IndentLine1.FINDSET THEN
                            REPEAT
                                IF IndentLine1.Approved = FALSE THEN
                                    ERROR('You can not released this indent order without approved all indent lines.');
                            UNTIL IndentLine1.NEXT = 0;
                        //PCPL41_05032020_E

                        //VK001-BEGIN
                        IF USer.GET(USERID) THEN
                            IF USer."Indent Releaser" = TRUE THEN BEGIN
                                Rec.Status := Rec.Status::Released;
                                CurrPage.IndentLines.PAGE.EDITABLE(FALSE);
                                Rec."Release User ID" := USERID;
                                Rec.MODIFY;
                            END ELSE
                                ERROR(Text002);


                        /*IndentLine.RESET;
                        IndentLine.SETRANGE(IndentLine."Document No.","No.");
                          IF  IndentLine.FINDFIRST THEN REPEAT
                            IF IndentLine.Approved = TRUE THEN BEGIN
                              Status := Status :: Released;
                              "Release User ID" := USERID;
                              MODIFY
                            END ELSE
                              ERROR('Please approve Indent before Releasing');
                              UNTIL IndentLine.NEXT = 0;
                        */

                        /*IF (Status = Status :: Released) THEN BEGIN
                          IndentLine.RESET;
                          IndentLine.SETRANGE(IndentLine."Document No.","No.");
                            IF IndentLine.FINDSET THEN REPEAT
                              IndentLine.Status := TRUE;
                              IndentLine.MODIFY;
                          UNTIL IndentLine.NEXT=0;
                        END;
                        
                        CurrPAGE.IndentLines.PAGE.EDITABLE(FALSE);
                        //VK001-END
                         */

                        Rec.Status := Rec.Status::Released;
                        Rec.MODIFY;
                        CurrPage.IndentLines.PAGE.EDITABLE(FALSE);
                        //VK001-END

                    end;
                }
            }
            action("<Action1000000015>")
            {
                Caption = 'Closed';
                Visible = false;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    Rec.VALIDATE(Status, Rec.Status::Closed);
                    Rec.MODIFY;
                end;
            }
            group(IncomingDocument)
            {
                visible = false;//PCPL-25/240323
                action(IncomingDocCard)
                {
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        IncomingDocument: Record 130;
                    begin
                        IncomingDocument.ShowCardFromEntryNo(Rec."Incoming Document Entry No.");        //PCPL-25
                    end;
                }
                action(SelectIncomingDoc)
                {
                    Caption = 'Select Incoming Document';
                    Enabled = NOT HasIncomingDocument;
                    Image = SelectLineToApply;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        IncomingDocument: Record 130;
                    begin
                        Rec.VALIDATE(Rec."Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument(Rec."Incoming Document Entry No.", Rec.RecordId));     //PCPL-25

                    end;
                }
                action(IncomingDocAttachFile)
                {
                    Caption = 'Create Incoming Document from File';
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    ApplicationArea = all;

                    trigger OnAction();
                    var
                        IncomingDocumentAttachment: Record 133;
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromIndentDocument(Rec);    //PCPL-25


                    end;
                }
                action(RemoveIncomingDoc)
                {
                    Caption = 'Remove Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = RemoveLine;
                    ApplicationArea = all;


                    trigger OnAction();
                    begin
                        Rec."Incoming Document Entry No." := 0;     //PCPL-25
                    end;
                }
            }
        }
        area(Processing)
        {
            action("Requisition Report")
            {
                Image = Print;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    IndentLine.RESET;
                    IndentLine.SETRANGE(IndentLine."Document No.", Rec."No.");
                    REPORT.RUNMODAL(50096, TRUE, TRUE, IndentLine);
                end;
            }
            // action("Indent Requisition")
            // {
            //     Image = Report;
            //     ApplicationArea = all;
            //     trigger OnAction();
            //     var
            //         RecIndentHeader: record "Indent Header";
            //     begin
            //         RecIndentHeader.Reset();
            //         RecIndentHeader.SetRange("No.", rec."No.");
            //         Report.RunModal(50098, true, true, RecIndentHeader);
            //     end;

            // }
            action("&Schedule Detail")
            {
                Caption = '&Schedule Detail';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Visible = false;        //PCPL-25/240323

                trigger OnAction();
                begin
                    /*IndentLine.RESET;
                    IndentLine.SETRANGE(IndentLine."Document No.",IndentLine."Document No.");
                    IF PAGE.RUNMODAL(50022)=ACTION::LookupOK THEN
                    Schedule.VALIDATE(Schedule."Document No",IndentLine."No.");
                    MESSAGE('%1',Schedule."Document No");
                    */
                    CurrPage.IndentLines.PAGE.ShowLineIndent;

                end;
            }
            action("Send For Approval")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                Description = 'PCPL-0070';
                trigger OnAction()
                var
                    UserSetup: Record 91;
                    ReqLine: Record "Indent Line";
                begin
                    //PCPL-25/100723
                    ReqLine.Reset();
                    ReqLine.SetRange("Entry Type", Rec."Entry Type");
                    ReqLine.SetRange("Document No.", Rec."No.");
                    //ReqLine.SetFilter(Type, '%1', ReqLine.Type::" ");
                    ReqLine.SetFilter("No.", '%1', '');
                    if ReqLine.FindFirst() then begin
                        Error('Please select Type and No. in line level');
                    end;

                    ReqLine.Reset();
                    ReqLine.SetRange("Entry Type", Rec."Entry Type");
                    ReqLine.SetRange("Document No.", Rec."No.");
                    if not ReqLine.FindFirst() then begin
                        Error('Please select Type and No. in line level');
                    end;
                    //PCPL-25/100723

                    if Rec.Status = Rec.Status::Open then begin
                        UserSetup.Get(UserId);
                        Rec.Status := Rec.Status::"Pending For Approval";
                        Rec."First Approver" := CurrentDateTime;
                        Rec."Approver ID" := UserSetup."User ID";
                        Rec.Modify();
                        Message('Your request has been send');
                    end Else
                        Error('Your status is alredy %1', Rec.Status);
                end;
            }
            action("Indent Cancellation") //pcpl-064 12dec2023
            {
                Caption = 'Indent Cancellation';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                    RecIndentHeader: Record "Indent Header";
                    Usersetup_1: Record "User Setup";
                begin
                    if Usersetup_1.Get(UserId) then begin
                        if Usersetup_1."Manual Indent Cancellation" = false then
                            Error('You do not have Permission');
                    end;
                    if Confirm('Do you want to Cancelled this Indent', true) then begin
                        RecIndentHeader.Reset();
                        RecIndentHeader.SetRange("Entry Type", RecIndentHeader."Entry Type"::Indent);
                        RecIndentHeader.SetRange("No.", Rec."No.");
                        RecIndentHeader.SetFilter(Status, '<>Closed');
                        RecIndentHeader.SetRange("Po Created", false);
                        if RecIndentHeader.FindFirst() then begin
                            //repeat
                            RecIndentHeader.Status := RecIndentHeader.Status::Cancelled;
                            RecIndentHeader."Po Created" := true;
                            RecIndentHeader.Modify();
                            CurrPage.Close();
                            Message('Indent Cancelled Successfully');
                            // CurrPage.Update();
                            // until RecIndentHeader.Next() = 0;

                        end;

                    end;
                end;
            }

        }
    }

    trigger OnAfterGetRecord();
    begin
        HasIncomingDocument := Rec."Incoming Document Entry No." <> 0;    //PCPL-25

        //VK001-BEGIN
        IF Rec.Status = Rec.Status::Released THEN
            //CurrPAGE.EDITABLE(FALSE)
            CurrPage.IndentLines.PAGE.EDITABLE(FALSE)
        ELSE
            //CurrPAGE.EDITABLE(TRUE);
            CurrPage.IndentLines.PAGE.EDITABLE(TRUE);
        //VK001-END
    end;

    trigger OnDeleteRecord(): Boolean;
    var
        UserSet: Record "User Setup";
        PL: Record "Purchase Line";
        ReqArchiH: Record "Requisition Archive Header";
        ReqArchiveLine: Record "Requisition Archive Lines";
        IndentLine: Record "Indent Line";
    begin
        CurrPage.SAVERECORD;
        //PCPL-25/080823
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
        CurrPage.Close();
    end;
    //PCPL-25/080823
    //end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        //VK001
        CurrPage.IndentLines.PAGE.EDITABLE(TRUE);
        //VK001
    end;

    trigger OnOpenPage();
    begin
        //VK001 -BEGIN
        //CurrPage.EDITABLE(FALSE);
        CurrPage.IndentLines.PAGE.EDITABLE(FALSE);

        //VK001 -END
    end;

    trigger OnModifyRecord(): Boolean
    Begin
        Rec.TestField(Status, Status::Open); //PCPL-25/280823

        if Rec.Status <> Rec.Status::Open then
            Error('You can not modify this document');
    End;

    //PCPL/0070 16Feb2023 <<
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        IndentLine: Record "Indent Line";
    Begin
        Rec.TestField(Purpose);
        Rec.TestField("Location Code");
        Rec.TestField("Type of Indent");
        Rec.TestField(Category);
        IndentLine.Reset();
        IndentLine.SetRange("Document No.", Rec."No.");
        if IndentLine.FindSet() then
            repeat
                IndentLine.TestField("No.");
                IndentLine.TestField(Quantity);
                IF Rec."Indent Type" <> Rec."Indent Type"::" " then begin
                    IndentLine."Indent Type" := Rec."Indent Type";
                    IndentLine.Modify();
                end;
            until IndentLine.Next() = 0;
    End;
    //PCPL/0070 16Feb2023 >>

    var
        indentheader: Record "Indent Header";
        IndentLine: Record 50023;
        Schedule: Record 50021;
        USer: Record 91;
        Text001: Label 'You do not have Authority to Reopen the Indent';
        Text002: Label 'You do not have Authority to Release the Indent. Kindly Contact Purchase Department.';
        IH: Record 50022;
        usersetup: Record 91;
        test: Text[100];
        no: Code[100];
        i: Integer;
        Email: Text[500];
        RecIL: Record 50023;
        IndentLine1: Record 50023;
        RecUser: Record 91;
        TmpLocCode: Text;
        HasIncomingDocument: Boolean;

}

