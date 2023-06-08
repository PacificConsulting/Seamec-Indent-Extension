report 50101 "RFQ Approval"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'src\ReportLayout/RFQ Approval.rdl';

    dataset
    {
        dataitem("RFQ Catalog"; "RFQ Catalog")
        {
            RequestFilterFields = "Document No.";
            DataItemTableView = order(ascending) where("Sequence No." = filter(<> 0));
            column(Document_No_; "Document No.")//
            {

            }
            column(Item_No_; "Item No.")
            {

            }
            column(Vessel_Name; Location.Code + '-' + Location.Name)
            {

            }
            column(Project_Code; RFQ_Hdr."Shortcut Dimension 2 Code")
            {

            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Total_Amount_LCY; "Total Amount LCY")
            {

            }
            column(Currency; Currency)
            {

            }
            column(Price; Price)
            {

            }
            column(CompanyInfo; CompanyInfo.Name)
            {

            }
            trigger OnAfterGetRecord()
            var
            Begin
                IF RFQ_Hdr.GET("Document No.") then begin
                    if RFQ_Hdr."Location Code" <> '' then
                        Location.GET(RFQ_Hdr."Location Code");
                end;
            End;

        }

    }

    // requestpage
    // {
    //     layout
    //     {
    //         area(Content)
    //         {
    //             group(GroupName)
    //             {
    //                 field(Name; SourceExpression)
    //                 {
    //                     ApplicationArea = All;

    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(processing)
    //         {
    //             action(ActionName)
    //             {
    //                 ApplicationArea = All;

    //             }
    //         }
    //     }
    // }
    trigger OnPreReport()
    begin
        CompanyInfo.GET;
    end;

    var
        myInt: Integer;
        Location: Record Location;
        RFQ_Hdr: Record "RFQ Header";
        CompanyInfo: Record "Company Information";
}