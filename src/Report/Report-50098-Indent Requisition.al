report 50098 "Indent Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout/Indent Requisition .rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Indent Header"; "Indent Header")
        {
            column(Status; Status)
            {
            }
            column(Location_Code; "Location Code")
            {

            }
            column(Created_By; "Created By")
            {

            }
            column(Indent_Due_Date; "Indent Due Date")
            {
            }
            column(Release_User_ID; "Release User ID")
            {

            }
            column(Cominfo; Cominfo.Picture)
            {

            }
            dataitem("Indent Line"; "Indent Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Line_No_; "Line No.")
                {

                }
                column(Description; Description)
                {

                }

                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure_Code; "Unit of Measure Code")
                {

                }
                column(Approved_Date; "Approved Date")
                {

                }
                column(Comment; Comment)
                {

                }
                column(Inventory_ROB; Inventory)
                {

                }
            }
            trigger OnPreDataItem()  //IH
            begin
                Cominfo.get();
                Cominfo.CalcFields(Picture);
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
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
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

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;
        Cominfo: Record "Company Information";
}