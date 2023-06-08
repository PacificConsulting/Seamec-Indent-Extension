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
            column(Month_Text; Month_Text)
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
            End;

        }

    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
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
                NameOfMonth := 'DEC’'
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
}