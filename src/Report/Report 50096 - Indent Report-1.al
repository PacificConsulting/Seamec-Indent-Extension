report 50096 "Indent Report-1"
{
    // version RSPL/INDENT/V3/001

    DefaultLayout = RDLC;
    RDLCLayout = 'src\ReportLayout/Indent Report -2.rdl';

    dataset
    {
        dataitem("Indent Line"; "Indent Line")
        {
            RequestFilterFields = "Document No.";
            column(IndentLine_Document_No; "Indent Line"."Document No.")
            {
            }
            column(IndentLine_No; "Indent Line"."No.")
            {
            }
            column(IndentLine_LocationCode; "Indent Line"."Location Code")
            {
            }
            column(IndentLine_VariantCode; "Indent Line"."Variant Code")
            {
            }
            column(IndentLine_Description; "Indent Line".Description)
            {
            }
            column(IndentLine_Description2; "Indent Line"."Description 2")
            {
            }
            column(IndentLine_UnitofMeasureCode; "Indent Line"."Unit of Measure Code")
            {
            }
            column(IndentLine_Quantity; "Indent Line".Quantity)
            {
            }
            column(IndentLine_RequirementDate; "Indent Line"."Requirement Date")
            {
            }
            column(IndentLine_Remark; "Indent Line".Remark)
            {
            }
            column(IndentLine_USERID; "Indent Line"."USER ID")
            {
            }
            column(Company_Name; CompInfo.Name)
            {
            }
            column(Today; FORMAT(TODAY, 0, 4))
            {
            }
            column(Company_Address; CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' Tele Phone No.' + CompInfo."Phone No." + ' Fax No.' + CompInfo."Fax No.")
            {
            }
            column(PageNo; '')
            {
            }
            column(CompInfo_Picture; CompInfo.Picture)
            {
            }
            column(IndentLine_Date; "Indent Line".Date)
            {
            }
            column(Location_Address; recLocation.Name + ',' + recLocation.Address + ',' + recLocation."Address 2" + ',' + recLocation.City + ',' + recLocation."State Code")
            {
            }
            column(ApprovedBy_IndentLine; "Indent Line"."Approved By")
            {
            }
            column(BinQuantity; BinQuantity)
            {
            }
            column(ROBQty; Inventory)
            {

            }
            column(SrNo; SrNo)
            {

            }
            column(ItemComment; ItemComment)
            {

            }
            column(Indentcomment; IndentHead.Comments)
            {

            }
            column(IndeDescription; IndentHead."Indent Description")
            {

            }
            column(Approved_date; "Indent Line"."Approved Date")
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompInfo.GET;
                CompInfo.CALCFIELDS(CompInfo.Picture);
                //PCPL-25/090323
                SrNo += 1;
                if IndentHead.Get("Document No.", "Entry Type") then;
                if recItem.Get("No.") then;
                Clear(ItemComment);
                commentLine.Reset();
                commentLine.SetRange("No.", "No.");
                commentLine.SetRange("Table Name", commentLine."Table Name"::Item);
                if commentLine.FindSet() then
                    repeat
                        if ItemComment = '' then
                            ItemComment := commentLine.Comment
                        else
                            ItemComment := ItemComment + ' ' + commentLine.Comment;
                    until commentLine.Next() = 0;
                //PCPL-25/090323

                IF recLocation.GET("Indent Line"."Location Code") THEN;
                BinQuantity := 0;
                BinContent.RESET;
                BinContent.SETRANGE("Item No.", "Indent Line"."No.");
                BinContent.SETRANGE("Location Code", "Indent Line"."Location Code");
                IF BinContent.FINDSET THEN
                    REPEAT
                        BinContent.CALCFIELDS(Quantity);
                        IF BinContent."Bin Code" = 'STORE-API' THEN
                            BinQuantity := BinQuantity + BinContent.Quantity
                        ELSE
                            IF BinContent."Bin Code" = 'STORE' THEN
                                BinQuantity := BinQuantity + BinContent.Quantity
                            ELSE
                                IF BinContent."Bin Code" = 'STORE-FORM' THEN
                                    BinQuantity := BinQuantity + BinContent.Quantity;
                    UNTIL BinContent.NEXT = 0;
            end;

            trigger OnPreDataItem();
            begin
                //CompInfo.GET;
                //CompInfo.CALCFIELDS(CompInfo.Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CompInfo: Record 79;
        recLocation: Record 14;
        BinContent: Record 7302;
        BinQuantity: Decimal;
        BinQuantityS: Decimal;
        BinQuantitySF: Decimal;
        SrNo: Integer;
        IndentHead: Record 50022;
        recItem: Record 27;
        commentLine: Record 97;
        ItemComment: Text;
}

