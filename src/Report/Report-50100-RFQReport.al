report 50100 RFQReport
{
    UsageCategory = ReportsAndAnalysis;
    Caption = 'RFQ Report';
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\ReportLayout/RFQ Report.rdl';

    dataset
    {
        dataitem("RFQ Header"; "RFQ Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(No_; "No.")
            {

            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {

            }
            column(Date; Date)
            {

            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {

            }
            column(CompanyInfo_Add; CompanyInfo.Address + CompanyInfo."Address 2" + CompanyInfo.City + ',' + CompanyInfo."State Code")
            {

            }
            column(CompanyInfo_PhoneNo; 'Tel No. : ' + CompanyInfo."Phone No.")
            {

            }
            column(CompanyInfo_FAX_No; 'FAX No.: ' + CompanyInfo."Fax No.")
            {

            }
            column(CompanyInfo_Email; 'E-mail :' + CompanyInfo."E-Mail")
            {

            }
            column(CompanyInfo_PAN; CompanyInfo."P.A.N. No.")
            {

            }
            column(Vessel_Name; Location_g.Code + '-' + Location_g.Name) { }
            column(SystemCreatedAt; SystemCreatedAt)
            {

            }
            dataitem("RFQ Catalog"; "RFQ Catalog")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = order(ascending) where("Sequence No." = filter(<> 0));
                column(Vendor_No_; "Vendor No." + '     ' + "Vendor Name")
                {

                }
                column(Vendor_No_1; "Vendor No.")
                {

                }
                column(Document_No_; "Document No.")
                {

                }
                column(SeqNo; SeqNo)
                {

                }
                column(Currency; Currency)
                {

                }
                column(Remark; Remarks)
                {

                }
                column(Exchange_Rate; CurrExRate."Relational Exch. Rate Amount")
                {

                }
                column(Line_Amount; "Total Amount")
                {

                }
                column(Total_Amount_LCY; "Total Amount LCY")
                {

                }
                trigger OnAfterGetRecord() //RFQ_Line
                var
                Begin
                    CurrExRate.Reset();
                    CurrExRate.SetRange("Currency Code", Currency);
                    IF CurrExRate.FindLast() then;

                    SeqNo += 1;
                End;
            }
            trigger OnAfterGetRecord() //RFQ_Hdr
            var
            Begin
                if "Location Code" <> '' then
                    Location_g.GET("Location Code");
            End;
        }
    }
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture);
    end;
    /*
     requestpage
     {
         layout
         {
             area(Content)
             {
                 group(GroupName)
                 {
                     field(Name; SourceExpression)
                     {
                         ApplicationArea = All;

                     }
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
     */
    var
        CompanyInfo: Record "Company Information";
        SeqNo: Integer;
        Location_g: Record Location;
        CurrExRate: Record "Currency Exchange Rate";
}