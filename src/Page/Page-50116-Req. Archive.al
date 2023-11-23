page 50116 "Requisition Archive"
{
    // version RSPL/INDENT/V3/001,PCPL-FA-1.0,PCPL-25/INCDoc

    // Name        Code        Description
    // Venkatesh   VK001       Introduce Release and Reopen Option
    Caption = 'Requisition Archive';
    Editable = true;
    PageType = Card;
    SourceTable = "Requisition Archive Header";
    SourceTableView = WHERE("Entry Type" = FILTER(Indent));
    DeleteAllowed = false; //PCPL-25/100723
    InsertAllowed = false;
    ModifyAllowed = false;


    layout
    {
        area(content)
        {
            field("No."; Rec."No.")
            {
                AssistEdit = true;
                ApplicationArea = All;

                // trigger OnAssistEdit();
                // begin
                //     IF Rec.AssistEdit(xRec) THEN
                //         CurrPage.UPDATE;
                // end;
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
            field("Deleted By"; Rec."Deleted By")
            {
                ApplicationArea = all;
            }
            field("Deleted Date"; Rec."Deleted Date")
            {
                ApplicationArea = all;
            }
            field(Comments; Rec.Comments)
            {
                ApplicationArea = all;
            }
            part(RequisitonArchiveLines; 50117)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {

    }

    /* trigger OnAfterGetRecord();
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
                 IF Rec."Indent Type" <> Rec."Indent Type"::" " then begin
                     IndentLine."Indent Type" := Rec."Indent Type";
                     IndentLine.Modify();
                 end;
             until IndentLine.Next() = 0;
     End;
     //PCPL/0070 16Feb2023 >>
 */
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

