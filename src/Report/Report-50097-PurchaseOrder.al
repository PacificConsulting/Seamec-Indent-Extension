report 50097 "Purchase Order"
{

    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout/Purchase Order -4.rdl';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "Posting Date";
            column(No_; "No.")
            {

            }
            column(Cominfo_Picture; Cominfo.Picture)
            {

            }
            column(Order_Date_PH; "Order Date")
            {

            }
            column(PurchaseOrderDue_Date_PH; "Due Date")
            {

            }
            column(Ship_to_Address_PH; "Ship-to Address")
            {

            }
            column(Telephone_vend_contact_PH; vend_contact)
            {

            }
            column(vend_GSTNO_PH; vend_GSTNO)
            {

            }
            column(Currency_Code; "Currency Code")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            column(Clauses; Clauses)
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
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
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(Unit_Price; "Direct Unit Cost")
                {

                }
                column(GSTBaseAmt; GSTBaseAmt)
                {

                }
                column(TotalAmt; TotalAmt)
                {

                }
                column(Comm; Comm)
                {

                }



                trigger OnAfterGetRecord() //PL

                begin
                    Clear(TotalAmt);
                    TotalAmt += "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost";

                    RecPurchCom.Reset();
                    RecPurchCom.SetRange("Document Type", "Document Type");
                    RecPurchCom.Setrange("No.", "Document No.");
                    if RecPurchCom.FindFirst() then
                        Comm := RecPurchCom.Comment;
                end;

            }
            trigger OnPreDataItem()  //PH
            begin
                Cominfo.get();
                Cominfo.CalcFields(Picture);

            end;

            trigger OnAfterGetRecord() //PH
            begin
                if Recvendor.get("Buy-from Vendor No.") then
                    vend_contact := Recvendor."Phone No.";
                vend_GSTNO := Recvendor."GST Registration No.";


                DGLE.Reset();
                DGLE.SetRange("Document No.", "No.");
                if DGLE.FindSet() then
                    GSTBaseAmt := DGLE."GST Base Amount";
            end;

        }

    }

    requestpage
    {
        layout
        {
            // area(Content)
            // {
            //     group(GroupName)
            //     {
            //         field(Name; SourceExpression)
            //         {
            //             ApplicationArea = All;

            //         }
            //     }
            // }
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



    var
        Cominfo: Record "Company Information";
        Recvendor: Record Vendor;
        vend_contact: Code[20];
        vend_GSTNO: code[20];
        DGLE: Record "Detailed GST Ledger Entry";
        GSTBaseAmt: Decimal;
        TotalAmt: Decimal;
        RecPurchCom: Record "Purch. Comment Line";
        Comm: Text[80];
}
