report 50102 "Purchase Indent"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    //  DefaultRenderingLayout = LayoutName;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            column(Number; Number)
            {

            }
            trigger OnPreDataItem()
            var
                myInt: Integer;
                RecPUrPayRcSet: Record "Purchases & Payables Setup";
            begin
                RecPUrPayRcSet.Reset();
                RecPUrPayRcSet.Get();
                RecPUrPayRcSet.TestField("Purchase Indent Deletion Date");
                SetRange(Number, 1, 1);
                Enddate := CalcDate('-' + Format(RecPUrPayRcSet."Purchase Indent Deletion Date"), WorkDate);
                IndHeader.Reset();
                // IndHeader.SetRange("No.", IndHeader."No.");
                IndHeader.SetFilter("Creation Date", '<%1', Enddate);
                //IndHeader.SetFilter("Creation Date", Format(CalcDate('<-90D')));
                //Message(Format(Enddate));
                IndHeader.SetFilter(Status, '<>Closed');
                IndHeader.SetRange("Po Created", false);
                if IndHeader.FindSet() then begin
                    repeat
                        Clear(Indentfound_PL);
                        Clear(Indentfound_RFQ);

                        RFQHeader.Reset();
                        RFQHeader.SetRange("No.", IndHeader."No.");
                        RFQHeader.SetRange("Created PO", false);
                        if RFQHeader.FindSet() then begin
                            Indentfound_RFQ := true;

                        end;

                        purchLines.Reset();
                        purchLines.SetRange("Indent No.", IndHeader."No.");
                        if purchLines.FindSet() then
                            Indentfound_PL := true;


                        // if Indentfound_RFQ = true or Indentfound_PL = true then begin
                        if Indentfound_PL = true then begin

                        end else begin
                            IndHeader.Status := IndHeader.Status::Cancelled;
                            IndHeader."Po Created" := true;
                            IndHeader.Modify();
                        end;

                    until IndHeader.Next() = 0;

                end;
            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    /* field(Name; SourceExpression)
                    {
                        ApplicationArea = All;

                    } */
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    /* rendering
    {
        layout(LayoutName)
        {
            Type = Excel;
            LayoutFile = 'mySpreadsheet.xlsx';
        }
    }
 */
    var
        myInt: Integer;
        IndHeader: Record "Indent Header";
        RFQHeader: Record "RFQ Header";
        purchLines: Record "Purchase Line";
        Enddate: Date;
        Archiveinden: Page "Archive Indent";
        Indentfound_PL: Boolean;
        Indentfound_RFQ: Boolean;
}