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
            column(Document_No_; Indent_Hdr."No." + ' - ' + Indent_Hdr."Indent Description")
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
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {

            }
            column(SumbitDate; SumbitDate)
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
            column(Vendor_No_; "Vendor No." + '-' + "Vendor Name")
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
            column(Month_Text; Month_Text)
            {

            }
            column(Total_Amount; "Total Amount")
            {

            }
            column(CostCentreCode; RFQ_Hdr."Shortcut Dimension 1 Code")
            {

            }
            trigger OnAfterGetRecord()
            var
            Begin
                IF RFQ_Hdr.GET("Document No.") then begin
                    if RFQ_Hdr."Location Code" <> '' then
                        Location.GET(RFQ_Hdr."Location Code");
                end;

                SumbitDate := DT2Date("Quotation Submited on");
                Month_Text := GetNameOfMonthFromDate(SumbitDate);

                Indent_Hdr.Reset();
                Indent_Hdr.SetRange("No.", "RFQ Catalog"."Document No.");
                if Indent_Hdr.FindFirst() then;
            End;

        }

    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture);
    end;

    procedure GetNameOfMonthFromDate(var GetDate: Date): Text[10]
    var
        ModValue: Decimal;
        NameOfMonth: Text[10];
        GetMonth: Integer;
    begin
        GetMonth := Date2DMY(GetDate, 2);
        Case GetMonth of
            1:
                NameOfMonth := 'JAN';
            2:
                NameOfMonth := 'FEB';
            3:
                NameOfMonth := 'MAR';
            4:
                NameOfMonth := 'APR';
            5:
                NameOfMonth := 'MAY';
            6:
                NameOfMonth := 'JUN';
            7:
                NameOfMonth := 'JUL';
            8:
                NameOfMonth := 'AUG';
            9:
                NameOfMonth := 'SEP';
            10:
                NameOfMonth := 'OCT';
            11:
                NameOfMonth := 'NOV';
            12:
                NameOfMonth := 'DEC';
        End;
        EXIT(NameOfMonth);
    end;

    var
        myInt: Integer;
        Location: Record Location;
        RFQ_Hdr: Record "RFQ Header";
        CompanyInfo: Record "Company Information";
        SumbitDate: date;
        Month_Text: Text[20];
        Indent_Hdr: Record "Indent Header";
}