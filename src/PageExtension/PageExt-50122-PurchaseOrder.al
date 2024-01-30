pageextension 50122 Purchase_order_Indent extends "Purchase Order"
{
    layout
    {
        addafter("Buy-from City")
        {
            field(Clauses; Rec.Clauses)
            {
                ApplicationArea = All;
            }
        }


    }

    actions
    {
        //PCPL-25/080823
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                PL: Record "Purchase Line";
            begin
                Rec.TestField("Location Code");
                PL.Reset();
                PL.SetRange("Document No.", Rec."No.");
                if PL.FindSet() then
                    repeat
                        PL.TestField("Location Code");
                    until PL.Next() = 0;
            end;
        }
        //PCPL-25/080823

        addafter("Archive Document")
        {

            action("Get Indent Line")
            {
                Image = Process;
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                PromotedCategory = Process;


                trigger OnAction();
                begin
                    PHEader.RESET;
                    PHEader.SETRANGE(PHEader."Document Type", PHEader."Document Type"::Order);
                    PHEader.SETRANGE("No.", Rec."No.");
                    IF PHEader.FINDFIRST THEN BEGIN
                        CurrPage.PurchLines.PAGE.GetIndentLines;
                    END;
                end;
            }

        }
        addafter("&Print")
        {
            action("Purchase Order Report")
            {
                Promoted = true;
                PromotedCategory = Report;
                Image = Print;
                ApplicationArea = all;
                trigger OnAction()

                begin
                    Rec.TestField(Clauses);
                    PH.Reset();
                    PH.SetRange("No.", Rec."No.");
                    if PH.FindFirst() then
                        Report.RunModal(50097, true, false, PH);
                end;

            }
        }
        addlast("Prepa&yment")
        {
            action("PO Cancelled")//pcpl-064 13dec2023
            {
                Caption = 'PO Cancelled';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    IndHeader: Record "Indent Header";
                    RFQHeader: Record "RFQ Header";
                    Usersetup_1: Record "User Setup";
                    Indentfound_RFQ: Boolean;
                    PurchLine: Record "Purchase Line";
                    purchheader: Record "Purchase Header";
                    purheadarchive: Record "Purchase Header Archive";

                begin
                    if Usersetup_1.Get(UserId) then begin
                        if Usersetup_1."Manual PO Cancellation" = false then
                            Error('You do not have Permission');
                    end;
                    // Rec."Cancelled PO" := true;
                    // rec.Modify();
                    if Confirm('Do you want to Cancelled this PO', true) then begin
                        ArchiveManagement.StorePurchDocument(Rec, false);
                        PurchLine.Reset();
                        PurchLine.SetRange("Document No.", rec."No.");
                        PurchLine.SetFilter("Indent No.", '<>%1', '');
                        if PurchLine.FindSet() then begin
                            repeat
                                purchheader.Reset();
                                purchheader.SetRange("No.", PurchLine."Document No.");
                                if purchheader.FindSet() then begin
                                    purchheader.Delete();
                                    purchheader.Modify();
                                end;
                                PurchLine.Delete();
                                PurchLine.Modify();
                            until PurchLine.Next() = 0;
                            purheadarchive.Reset();
                            purheadarchive.SetRange("No.", rec."No.");
                            if purheadarchive.FindLast() then begin
                                purheadarchive."PO Cancelled" := true;
                                purheadarchive.Modify();
                            end;
                            ArchiveManagement.StorePurchDocument(Rec, false);
                        end;
                        Message('PO Cancelled Successfully');
                        /* RFQHeader.Reset();
                        RFQHeader.SetRange("No.", PurchLine."Indent No.");
                        //RFQHeader.SetRange("Created PO", false);
                        if RFQHeader.FindFirst() then begin
                            RFQHeader.Status := RFQHeader.Status::Cancelled;
                            RFQHeader."Created PO" := true;
                            RFQHeader."PO Cancelled" := true;
                            RFQHeader.Modify(); */
                        //CurrPage.Update();
                        //CurrPage.Close();
                        //end;
                        /*  IndHeader.Reset();
                         IndHeader.SetRange("Entry Type", IndHeader."Entry Type"::Indent);
                         //IndHeader.SetFilter(Status, '<>Closed');
                         //IndHeader.SetRange("Po Created", false);
                         IndHeader.SetRange("No.", PurchLine."Indent No.");
                         if IndHeader.FindFirst() then begin
                             //if IndHeader.Get(rec."No.") then begin
                             IndHeader.Status := IndHeader.Status::Cancelled;
                             IndHeader."Po Created" := true;
                             IndHeader."PO Cancelled" := true;
                             IndHeader.Modify(); */

                    end;

                end;
                // end;

                //end;
                //pcpl-064 13dec2023


            }
        }
    }

    var
        PHEader: Record 38;
        PH: Record "Purchase Header";
        ArchiveManagement: Codeunit ArchiveManagement;
}