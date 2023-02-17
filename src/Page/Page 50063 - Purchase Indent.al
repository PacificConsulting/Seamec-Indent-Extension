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
                OptionCaption = '" ,Engineering,Raw Materials,Lab Equipment,Lab Chemicals,Packing Material,Safety,Production,Information Technology,Bldg. No1,Bldg No.2,Bldg No.3,QA,Warehouse,SRP,ETP & MEE,Utility,Formulation,Stationary,API block,Warehouse Block,Administration,QC & QA,UG water Storage Tank,UG solvent storage Tank farm,Intermediate Block,Hydrogenation Block,Utility Block-1,Utility Block-2,Distillation block,Road drainages & compound wall,EHS,Transformer yard,Security Cabin"';
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
                                Rec.Status := Status::Open;
                                CurrPage.IndentLines.PAGE.EDITABLE(TRUE);
                                Rec.MODIFY;
                            END ELSE
                                ERROR(Text001);


                        //VK001-End
                        IF Rec.Status = Status::Open THEN BEGIN
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
        area(processing)
        {
            action("Indent Report-1")
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
            action("&Schedule Detail")
            {
                Caption = '&Schedule Detail';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

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
                begin
                    UserSetup.Get(UserId);
                    Rec.Status := Rec.Status::"Pending For Approval";
                    Rec."First Approver" := CurrentDateTime;
                    Rec."Approver ID" := UserSetup."User ID";
                    Rec.Modify();
                    Message('Your request has been send');
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
    begin
        CurrPage.SAVERECORD;
    end;

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
            until IndentLine.Next() = 0;
    End;
    //PCPL/0070 16Feb2023 >>

    var
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

