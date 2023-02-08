page 50088 "Final Indent for Approval"
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
                OptionCaption = '" ,Engineering,Raw Materials,Lab Equipment,Lab Chemicals,Packing Material,Safety,Production,Information Technology,Bldg. No1,Bldg No.2,Bldg No.3,QA,Warehouse,SRP,ETP & MEE,Utility,Formulation,Stationary,API block,Warehouse Block,Administration,QC & QA,UG water Storage Tank,UG solvent storage Tank farm,Intermediate Block,Hydrogenation Block,Utility Block-1,Utility Block-2,Distillation block,Road drainages & compound wall,EHS,Transformer yard,Security Cabin"';
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
                    Image = Approval;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.Status := Rec.Status::Released;
                        //Rec."Second Approver" := CurrentDateTime;
                        Rec."Release User ID" := UserId;
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

