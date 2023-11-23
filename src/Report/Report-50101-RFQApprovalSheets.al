report 50101 "RFQ Approval"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout\RFQ Approval - 1.rdl';

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
            column(Item_No_; "Item No." + ' - ' + Rec_Item.Description)
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
            column(TotalPrice; TotalPrice) { }
            column(TotalAmt; TotalAmt) { }
            column(TotalAmtLCY; TotalAmtLCY) { }
            trigger OnAfterGetRecord()
            var
            Begin
                Clear(TotalPrice);
                Clear(TotalAmt);
                Clear(TotalAmtLCY);
                IF RFQ_Hdr.GET("Document No.") then begin
                    if RFQ_Hdr."Location Code" <> '' then
                        Location.GET(RFQ_Hdr."Location Code");
                end;

                SumbitDate := DT2Date("Quotation Submited on");
                Month_Text := GetNameOfMonthFromDate(SumbitDate);

                Indent_Hdr.Reset();
                Indent_Hdr.SetRange("No.", "RFQ Catalog"."Document No.");
                if Indent_Hdr.FindFirst() then;

                IF Rec_Item.GET("Item No.") then;

                //PCPL-0070 12July <<
                // if VendorNo <> "Vendor No." then begin
                RfqC.Reset();
                RfqC.SetCurrentKey("Vendor No.");
                RfqC.SetAscending("Vendor No.", true);
                RfqC.SetRange("Document No.", "RFQ Catalog"."Document No.");
                RfqC.SetRange("Vendor No.", "RFQ Catalog"."Vendor No.");
                RfqC.SetFilter("Sequence No.", '<>%1', 0);
                IF RfqC.FindSet() then
                    repeat
                        TotalPrice += RfqC.Price;
                        TotalAmt += RfqC."Total Amount";
                        TotalAmtLCY += RfqC."Total Amount LCY";
                    until RfqC.Next() = 0;
                // end;
                VendorNo := "Vendor No.";
                //PCPL-0070 12July >>
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
        Rec_Item: Record Item;
        RfqC: Record "RFQ Catalog";
        TotalPrice: Decimal;
        TotalAmt: Decimal;
        TotalAmtLCY: Decimal;
        VendorNo: Code[20];
}