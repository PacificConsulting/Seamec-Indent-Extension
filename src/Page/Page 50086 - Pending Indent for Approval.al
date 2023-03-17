page 50086 "Pending Indent for Approval"
{
    // version RSPL/INDENT/V3/001,PCPL-FA-1.0,PCPL-25/INCDoc

    // Name        Code        Description
    // Venkatesh   VK001       Introduce Release and Reopen Option

    Editable = true;
    PageType = Card;
    SourceTable = 50022;
    //SourceTableView = WHERE("Entry Type" = FILTER(Indent));

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
            part(IndentLines; 50064)
            {
                ApplicationArea = all;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Approvals)
            {
                action("Approve")
                {
                    Caption = 'Approve';
                    //Image = SendApprovalRequest;
                    Image = Approval;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::"First Approval";
                        Rec."Second Approver" := CurrentDateTime;
                        Rec.Modify();
                    end;
                }
                action(Cancel)
                {
                    Image = Cancel;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Open;
                        Rec.Modify();
                    end;
                }
            }
        }
    }
}

