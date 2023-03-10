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
            column(RFQ_Indent_No_; "RFQ Indent No.")
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
            column(Project_Code; "Shortcut Dimension 2 Code")
            {

            }
            column(Buy_from_Vendor_No_Supplier; "Buy-from Vendor No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Buy_from_Address; "Buy-from Address" + '' + "Buy-from Address 2")

            {

            }
            column(Buy_from_Contact; "Buy-from Contact" + ',' + "Buy-from Contact No.")
            {

            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Line_No_; "Line No.")
                {

                }
                column(Item_No_; "No.")
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
                column(TotalPoValues; TotalPoValues)
                {

                }
                // column(Comm; Comm)
                // {

                // }
                dataitem("Purch. Comment Line"; "Purch. Comment Line")
                {
                    DataItemLink = "Document Line No." = field("Line No.");
                    column(Comment; Comment)
                    {

                    }
                    column(Line_No_comments; "Line No.")
                    {

                    }

                    column(Document_Line_No_; "Document Line No.")
                    {

                    }
                    column(iscomment; iscomment)
                    {

                    }
                    trigger OnAfterGetRecord() //PCL
                    begin
                        if "Document Line No." <> lineno then begin
                            iscomment := false;
                            lineno := "Document Line No."

                        end
                        else
                            iscomment := true;

                    end;
                }




                trigger OnAfterGetRecord() //PL

                begin
                    Clear(TotalAmt);
                    TotalAmt += "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost";
                    //TotalPoValues += TotalAmt + DGLE."GST Base Amount";
                    //Message(format(TotalPoValues));

                    // RecPurchCom.Reset();
                    // RecPurchCom.SetRange("Document Type", "Purchase Line"."Document Type"::Order);
                    // RecPurchCom.SetRange("Document Line No.", "Purchase Line"."Line No.");
                    // RecPurchCom.Setrange("No.", "Purchase Line"."Document No.");
                    // if RecPurchCom.FindFirst() then
                    //     repeat
                    //         Comm := RecPurchCom.Comment;
                    //     until RecPurchCom.Next = 0;


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
                //Projectcode := Recvendor."Global Dimension 1 Code";


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
        lineno: Integer;
        iscomment: Boolean;
        TotalPoValues: Decimal;
        RecIndent: Record "Indent Header";
        IndentNo: Code[20];

}
