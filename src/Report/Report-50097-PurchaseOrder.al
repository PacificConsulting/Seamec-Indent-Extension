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
            column(SGST; SGST)
            {

            }
            column(CGST; CGST)
            {
            }
            column(IGST; IGST)
            {

            }
            column(TotalTaxAmount; TotalTaxAmount)
            {
            }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Document_No_; "Document No.")
                {

                }

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
                column(Amount; Amount)
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
                    clear(TotalTaxAmount);

                    TotalAmt += "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost";
                    //TotalAmount1 += Amount + SGST + CGST + IGST;
                    //TotalPoValues += Amount + SGST + CGST + IGST;
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
                //GST
                // TotalTaxAmount := 0;
                TotalTaxAmount := SGST + CGST + IGST;
                GetSalesStatisticsAmount("Purchase Header", TotalGSTAmount, TotalGSTPercent);

                //Currencycode 17march2023
                if "Currency Code" <> '' then
                    "Currency Code" := "Purchase Header"."Currency Code"
                else
                    "Currency Code" := 'INR';
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
        CGST: Decimal;
        IGST: Decimal;
        SGST: Decimal;
        CGSTPer: Decimal;
        SGSTPer: Decimal;
        IGSTPer: Decimal;
        IGSTLbl: Label 'IGST';
        SGSTLbl: Label 'SGST';
        CGSTLbl: Label 'CGST';
        CESSLbl: Label 'CESS';
        GSTLbl: Label 'GST';
        GSTCESSLbl: Label 'GST CESS';
        TotalAmount: decimal;
        TotalGSTAmount: decimal;
        TotalGSTPercent: decimal;
        TotalTaxAmount: Decimal;
        currencycode: code[20];





    //GST calculate 16march2023
    procedure GetSalesStatisticsAmount(
PurchHeader: Record "Purchase Header";
var GSTAmount: Decimal; var GSTPercent: Decimal)
    var
        PurchLine: Record "Purchase Line";
    begin
        CGST := 0;
        IGST := 0;
        SGST := 0;
        CGSTPer := 0;
        SGSTPer := 0;
        IGSTPer := 0;
        Clear(CGST);
        Clear(IGST);
        Clear(SGST);
        // Clear(IGSTAmt);
        // Clear(IGSTPercent);
        // Clear(SGSTPercent);
        // Clear(CGSTPercent);

        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document no.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(PurchLine.RecordId());
                GSTPercent += GetGSTPercent(PurchLine.RecordId());
                TotalAmount += PurchLine."Line Amount" - PurchLine."Line Discount Amount";
                GetGSTAmounts(PurchLine);
            until PurchLine.Next() = 0;
    end;

    local procedure GetGSTAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then begin
            TaxTransactionValue.CalcSums(Amount);
            TaxTransactionValue.CalcSums(Percent);
            /*  if TaxTransactionValue."Value ID" = 6 then begin
                 SGSTAmt += TaxTransactionValue.Amount;
                 SGSTPercent += TaxTransactionValue.Percent;
             end;
             if TaxTransactionValue."Value ID" = 2 then begin
                 CGSTAmt += TaxTransactionValue.Amount;
                 CGSTPercent += TaxTransactionValue.Percent;
             end;
             if TaxTransactionValue."Value ID" = 3 then begin
                 IGSTAmt += TaxTransactionValue.Amount;
                 IGSTPercent += TaxTransactionValue.Percent;
             end; */
        end;
        exit(TaxTransactionValue.Amount);
    end;

    local procedure GetGSTPercent(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Percent);

        exit(TaxTransactionValue.Percent);
    end;

    local procedure GetGSTAmounts(Purchline: Record "Purchase Line")
    var
        ComponentName: Code[30];
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        ComponentName := GetComponentName(Purchline, GSTSetup);

        if (Purchline.Type <> Purchline.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", Purchline.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                CGST += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                SGST += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGST += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        if not GSTSetup.Get() then
            exit;
        GSTSetup.TestField("GST Tax Type");

        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxComponent.SetRange(Name, ComponentName);
        TaxComponent.FindFirst();
        if TaxComponent."Rounding Precision" <> 0 then
            GSTRoundingPrecision := TaxComponent."Rounding Precision"
        else
            GSTRoundingPrecision := 1;
        exit(GSTRoundingPrecision);
    end;

    local procedure GetComponentName(Purchline: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchLine."GST Jurisdiction Type" = PurchLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

}
