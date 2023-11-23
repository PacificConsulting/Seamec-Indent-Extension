report 50097 "Purchase Order"
{

    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout/Purchase Order-2.rdl';
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
            column(PurchaseOrderDue_Date_PH; "Expected Receipt Date")
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
            column(Payment_Terms_Code; PayTerms.Code + ' - ' + PayTerms.Description)
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

            column(TotalTaxAmount; TotalTaxAmount)
            {
            }
            column(TotalAmount1; TotalAmount1)
            {

            }
            column(PO_Comment; Comm)
            {

            }
            column(JobMaintenanceNo; JobMaintenanceNo)
            {
                Description = 'PCPL-0070 05/05/23';
            }
            column(Vendphoneno; Vendphoneno)
            {

            }
            // dataitem("Purch. Comment Line1"; "Purch. Comment Line")
            // {
            //     DataItemLink = "No." = field("No.");
            //     column(PO_Comment; Comment)
            //     {
            //     }

            // }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");
                // Document No.=FIELD(No.),Line No.=FIELD(Line No.) 
                column(SGSTAmount; SGSTAmount)
                {

                }
                column(CGSTAmount; CGSTAmount)
                {
                }
                column(IGSTAmount; IGSTAmount)
                {

                }
                column(Document_No_; "Document No.")
                {

                }

                column(Line_No_; "Line No.")
                {

                }
                column(Item_No_; "No.")
                {

                }
                column(ItemDetails; recitem."Item Details")
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure; "Unit of Measure Code")
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
                column(TotalGSTAmountFinal; TotalGSTAmountFinal)
                {

                }



                dataitem("Purch. Comment Line"; "Purch. Comment Line")
                {
                    DataItemLink = "Document Line No." = field("Line No."), "No." = field("Document No.");
                    column(Purch_Comment_Line; Comment)
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
                        //Message("No.");
                        //Message('hello');

                    end;

                }




                trigger OnAfterGetRecord() //PL

                begin
                    Clear(TotalAmt);
                    clear(TotalTaxAmount);
                    if recitem.GET("Purchase Line"."No.") THEN;  //PCPL-25/130723


                    TotalAmt += "Purchase Line".Quantity * "Purchase Line"."Direct Unit Cost";

                    GetGSTAmountLinewise("Purchase Line", TotalGSTAmountlinewise, TotalGSTPercent);

                    IF PurchHedr.get("Purchase Line"."Document Type", "Purchase Line"."Document No.") then
                        TotalGSTAmountFinal := GSTFooterTotal(PurchHedr);

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

                GetPurchaseStatisticsAmount("Purchase Header", TotalGSTAmount, TotalGSTPercent);


                //Currencycode 17march2023
                if "Currency Code" <> '' then
                    "Currency Code" := "Purchase Header"."Currency Code"
                else
                    "Currency Code" := 'INR';


                //TotalAmount
                recPurchLine.RESET;
                recPurchLine.SETRANGE(recPurchLine."Document No.", "Purchase Header"."No.");
                //recPurchLine.SETRANGE(Type, recPurchLine.Type::Item);//PCPL-25/130723 code comment
                //recPurchLine.SetFilter(Type, '%1|%2', recPurchLine.Type::Item, recPurchLine.Type::"G/L Account");     
                IF recPurchLine.FINDSET THEN
                    REPEAT
                        TotalAmount1 += recPurchLine.Amount;
                    UNTIL recPurchLine.NEXT = 0;

                //20Mar2023
                RecPurchCom.Reset();
                RecPurchCom.SetRange("Document Type", "Purchase Header"."Document Type"::Order);
                RecPurchCom.Setrange("No.", "Purchase Header"."No.");
                if RecPurchCom.FindFirst() then
                    Comm := RecPurchCom.Comment;

                //PCPL-0070 050523 <<
                IF RFQHdr.GET("RFQ Indent No.") then begin
                    JobMaintenanceNo := RFQHdr."Job Maintenance No.";
                end;
                //PCPL-0070 050523 >>
                IF PayTerms.GET("Payment Terms Code") then;

                //Phone //PCPL-064 18/0723
                if vend.get(RecPH."Buy-from Vendor No.") then;
                if vend."Mobile Phone No." <> '' then
                    vendphoneno := vend."Phone No." + '/' + vend."Mobile Phone No."
                else
                    vendphoneno := vend."Phone No.";
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
        recitem: Record Item;
        vend: Record Vendor;
        RecPH: Record "Purchase Header";
        Vendphoneno: Text[30];
        PayTerms: Record "Payment Terms";
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
        TotalAmount1: Decimal;
        TotalGSTAmount: decimal;
        TotalGSTPercent: decimal;
        TotalTaxAmount: Decimal;
        currencycode: code[20];
        TotalGSTAmountFinal: Decimal;
        CGSTAmount: Decimal;
        SGSTAmount: Decimal;
        IGSTAmount: Decimal;
        PurchHedr: Record "Purchase Header";
        recPurchLine: Record "Purchase Line";
        CessAmount: Decimal;
        GSTComponentCodeName: array[20] of Code[20];
        TotalGSTAmountlinewise: Decimal;
        JobMaintenanceNo: Code[20]; //PCPL-0070 050523
        RFQHdr: Record "RFQ Header"; //PCPL-0070 050523
    //GST calculate 16march2023
    procedure GetPurchaseStatisticsAmount(
         PurchaseHeader: Record "Purchase Header";
         var GSTAmount: Decimal; var GSTPercent: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(GSTAmount);
        Clear(GSTPercent);
        Clear(TotalAmount);
        Clear(CGSTAmount);
        Clear(SGSTAmount);
        Clear(IGSTAmount);
        Clear(IGSTPer);
        Clear(SGSTPer);
        Clear(CGSTPer);

        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(PurchaseLine.RecordId());
                GSTPercent += GetGSTPercent(PurchaseLine.RecordId());
                TotalAmount += PurchaseLine."Line Amount" /*- PurchaseLine."Line Discount Amount"*/ - PurchaseLine."Inv. Discount Amount";//PCPL/NSW/170222
                GetGSTAmountsTotal(PurchaseLine);
            until PurchaseLine.Next() = 0;
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
            /*
            if TaxTransactionValue."Value ID" = 6 then begin
                SGSTAmount += TaxTransactionValue.Amount;
                SGSTPer += TaxTransactionValue.Percent;
                // message('%1', SGSTAmt);
            end;
            if TaxTransactionValue."Value ID" = 2 then begin
                CGSTAmount += TaxTransactionValue.Amount;
                CGSTPer += TaxTransactionValue.Percent;
            end;
            if TaxTransactionValue."Value ID" = 3 then begin
                IGSTAmount += TaxTransactionValue.Amount;
                IGSTPer += TaxTransactionValue.Percent;
            end;
            */
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

    local procedure GetGSTAmounts(PurchaseLine: Record "Purchase Line")
    var
        ComponentName: Code[30];
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmount := Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmount := Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSTAmount := Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetGSTAmountsTotal(PurchaseLine: Record "Purchase Line")
    var
        ComponentName: Code[30];
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        ComponentName := GetComponentName("Purchase Line", GSTSetup);

        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
            TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    case TaxTransactionValue."Value ID" of
                        6:
                            begin
                                SGSTAmount += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                SGSTPer := TaxTransactionValue.Percent;
                            end;
                        2:
                            begin
                                CGSTAmount += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                CGSTPer := TaxTransactionValue.Percent;
                            end;
                        3:
                            begin
                                IGSTAmount += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                IGSTPer := TaxTransactionValue.Percent;
                            end;
                    end;
                until TaxTransactionValue.Next() = 0;
        end;
    end;


    local procedure GetCessAmount(TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup")
    begin
        if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
            TaxTransactionValue.Reset();
            TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."Cess Tax Type");
            TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
            if TaxTransactionValue.FindSet() then
                repeat
                    CessAmount += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(GetComponentName(PurchaseLine, GSTSetup)));
                until TaxTransactionValue.Next() = 0;
        end;
    end;

    local procedure GetGSTCaptions(TaxTransactionValue: Record "Tax Transaction Value";
        PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup")
    begin
        TaxTransactionValue.Reset();
        TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
        TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if TaxTransactionValue.FindSet() then
            repeat
                case TaxTransactionValue."Value ID" of
                    6:
                        GSTComponentCodeName[6] := SGSTLbl;
                    2:
                        GSTComponentCodeName[2] := CGSTLbl;
                    3:
                        GSTComponentCodeName[3] := IGSTLbl;
                end;
            until TaxTransactionValue.Next() = 0;
    end;

    local procedure GetComponentName(PurchaseLine: Record "Purchase Line";
        GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        if GSTSetup."GST Tax Type" = GSTLbl then
            if PurchaseLine."GST Jurisdiction Type" = PurchaseLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl
        else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;
        exit(ComponentName)
    end;

    // local procedure GetTDSAmount(TaxTransactionValue: Record "Tax Transaction Value";
    //     PurchaseLine: Record "Purchase Line";
    //     TDSSetup: Record "TDS Setup")
    // begin
    //     if (PurchaseLine.Type <> PurchaseLine.Type::" ") then begin
    //         TaxTransactionValue.Reset();
    //         TaxTransactionValue.SetRange("Tax Record ID", PurchaseLine.RecordId);
    //         TaxTransactionValue.SetRange("Tax Type", TDSSetup."Tax Type");
    //         TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
    //         TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
    //         if TaxTransactionValue.FindSet() then
    //             repeat
    //                 TDSAmt += TaxTransactionValue.Amount;
    //             until TaxTransactionValue.Next() = 0;
    //     end;
    //     TDSAmt := Round(TDSAmt, 1);
    // end;

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

    procedure GetGSTAmountLinewise(
        PurchaseLine: Record 39;
        var GSTAmount: Decimal; var GSTPercent: Decimal)
    var
        PurchaseLine1: Record "Purchase Line";
    begin
        Clear(GSTAmount);
        Clear(GSTPercent);
        Clear(TotalAmount);
        Clear(CGSTAmount);
        Clear(SGSTAmount);
        Clear(IGSTAmount);
        Clear(IGSTPer);
        Clear(SGSTPer);
        Clear(CGSTPer);

        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseLine."Document No.");
        PurchaseLine.SetRange(PurchaseLine."Line No.", PurchaseLine."Line No.");
        if PurchaseLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(PurchaseLine.RecordId());
                GSTPercent += GetGSTPercent(PurchaseLine.RecordId());
                TotalAmount += PurchaseLine."Line Amount" /*- PurchaseLine."Line Discount Amount"*/ - PurchaseLine."Inv. Discount Amount";//PCPL/NSW/170222
                GetGSTAmounts(PurchaseLine);
            until PurchaseLine.Next() = 0;
    end;

    procedure GSTFooterTotal(PurchaseHeader: Record "Purchase Header"): Decimal

    var
        PurchaseLine: Record "Purchase Line";
        GSTAmountFooter: Decimal;
    begin
        // Clear(GSTAmount);
        // Clear(GSTPercent);
        // Clear(TotalAmount);
        // Clear(CGSTAmount);
        // Clear(SGSTAmount);
        // Clear(IGSTAmount);
        // Clear(IGSTPer);
        // Clear(SGSTPer);
        // Clear(CGSTPer);

        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document no.", PurchaseHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                GSTAmountFooter += GetGSTAmountFooter(PurchaseLine.RecordId());
            until PurchaseLine.Next() = 0;
        exit(GSTAmountFooter);
    end;

    local procedure GetGSTAmountFooter(RecID: RecordID): Decimal
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

        end;


        exit(TaxTransactionValue.Amount);
    end;

}
