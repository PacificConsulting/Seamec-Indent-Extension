page 50066 "Indent Line List"
{
    // version RSPL/INDENT/V3/001

    // //sh new functions
    // //SetIndentHeader
    // //IsFirstDocLine
    // //CreateIndentLines
    // //SetPurchHeaderIndent


    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PageType = List;
    RefreshOnActivate = true;
    SaveValues = false;
    SourceTable = 50023;
    SourceTableView = SORTING("Entry Type", "Document No.", "Line No.")
                      ORDER(Ascending)
                      WHERE("Entry Type" = FILTER(Indent),
                           // Close = CONST(False));
                           Generate = CONST(false));   //PCPL-25/280823
    ApplicationArea = all;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(Control0001)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                }
                field(Type; Rec.Type)
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("Requirement Date"; Rec."Requirement Date")
                {
                    ApplicationArea = all;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                }
                field("End Use"; Rec."End Use")
                {
                    ApplicationArea = all;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = all;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        IF USer.GET(USERID) THEN
                            IF USer."Indent Approver" = FALSE THEN BEGIN
                                ERROR('You cannot approve the Indent')
                            END ELSE
                                IF Rec.Approved = TRUE THEN BEGIN
                                    Rec."Approved By" := USERID;
                                    Rec."Approved Date and Time" := CURRENTDATETIME
                                END ELSE
                                    Rec."Approved By" := '';


                        IF Rec.Approved = TRUE THEN
                            Rec.TESTFIELD(Remark);

                        RecIH.RESET;
                        RecIH.SETRANGE(RecIH."No.", Rec."Document No.");
                        IF RecIH.FINDFIRST THEN BEGIN
                            IF RecIH.Category = 'ENGINEERING' THEN
                                IF Rec.Approved = TRUE THEN
                                    Rec.TESTFIELD("End Use");
                        END;
                    end;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        IF USer.GET(USERID) THEN
                            IF USer."Indent Releaser" = FALSE THEN BEGIN
                                ERROR('You cannot Release the Indent')
                            END;
                    end;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field("Material Requisitioned"; Rec."Material Requisitioned")
                {
                    ApplicationArea = all;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // field(Close; Rec.Close)
                // {

                //     ApplicationArea = all;
                //     trigger OnValidate();
                //     begin
                //         CloseOnPush;
                //     end;
                // }
                // field("Comment for Close"; Rec."Comment for Close")
                // {
                //     Caption = 'Comment for Close';
                //     ApplicationArea = all;
                // }
                field("Release Date and Time"; Rec."Release Date and Time")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Approved Date and Time"; Rec."Approved Date and Time")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Releaser User ID"; Rec."Releaser User ID")
                {
                    Editable = false;
                    ApplicationArea = all;
                }
                field("Outstanding Quantity"; Rec.Quantity - Rec."PO Qty")
                {
                    BlankNumbers = BlankZero;
                    BlankZero = true;
                    Caption = 'Outstanding Quantity';
                    NotBlank = false;
                    ApplicationArea = all;

                    trigger OnValidate();
                    begin
                        QuantityPOQtyOnAfterValidate;
                    end;
                }
                field(Closingqty; Rec.Closingqty)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        IF CloseAction = ACTION::LookupOK THEN
            LookupOKOnPush;
    end;

    var
        PurchHeader: Record 38;
        PurchRcptHeader: Record 120;
        TempIndentLine: Record 50023 temporary;
        GetReceipts: Codeunit 74;
        purchline: Record 39;
        PurcIndnettLine: Record 50023;
        IndentLine: Record 50023;
        IndentLineRec: Record 50023;
        Ok: Boolean;
        USer: Record 91;
        RecIH: Record 50022;

    procedure SetIndentHeader(var PurchHeader2: Record 38);
    begin
        PurchHeader.RESET;
        PurchHeader.SETRANGE(PurchHeader."Document Type", PurchHeader2."Document Type");
        PurchHeader.SETRANGE(PurchHeader."No.", PurchHeader2."No.");
        /*
        PurchHeader.GET(PurchHeader2."Document Type", PurchHeader2."No.");
        PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::Order);
        */

    end;

    local procedure IsFirstDocLine(): Boolean;
    var
        IndentLine: Record 50023;
    begin
        TempIndentLine.RESET;
        TempIndentLine.COPYFILTERS(Rec);
        TempIndentLine.SETRANGE("Document No.", Rec."Document No.");
        IF NOT TempIndentLine.FIND('-') THEN BEGIN
            IndentLine.COPYFILTERS(Rec);
            IndentLine.SETRANGE("Document No.", Rec."Document No.");
            IndentLine.FIND('-');
            TempIndentLine := IndentLine;
            TempIndentLine.INSERT;
        END;
        IF Rec."Line No." = TempIndentLine."Line No." THEN
            EXIT(TRUE);
    end;

    procedure CreateIndentLines(var PurchIndentLine2: Record 50023);
    var
        TransferLine: Boolean;
        DimMgt: Codeunit 408;
    begin
        WITH PurchIndentLine2 DO BEGIN
            SETFILTER(Quantity, '<>0');
            IF FIND('-') THEN BEGIN
                purchline.LOCKTABLE;
                purchline.SETRANGE("Document Type", PurchHeader."Document Type");
                purchline.SETRANGE("Document No.", PurchHeader."No.");
                purchline."Document Type" := PurchHeader."Document Type";
                purchline."Document No." := PurchHeader."No.";

                REPEAT
                    PurcIndnettLine := PurchIndentLine2;
                    PurcIndnettLine.InsertPurchLineFromIndentLine(purchline);
                // DimMgt.MoveTempFromDimToTempToDim(TempFromLineDim,TempToLineDim);
                UNTIL NEXT = 0;
                //  DimMgt.TransferTempToDimToDocDim(TempToLineDim);
            END;
        END;
    end;

    procedure SetPurchHeaderIndent(var PurchHeader2: Record 38);
    begin
        PurchHeader.RESET;
        PurchHeader.SETRANGE(PurchHeader."Document Type", PurchHeader2."Document Type");
        PurchHeader.SETRANGE(PurchHeader."No.", PurchHeader2."No.");
        PurchHeader.SETRANGE(PurchHeader."Location Code", PurchHeader2."Location Code");
        IF PurchHeader.FINDFIRST THEN;
        /*
        PurchHeader.GET(PurchHeader2."Document Type", PurchHeader2."No.");
        PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::Order);
        */
        //PurchHeader.TESTFIELD("Document Type",PurchHeader."Document Type"::Order);

    end;

    procedure ShowLineIndent();
    begin
        Rec.ShowLineComments;
    end;

    procedure GetBinContents();
    var
        ILine: Record 50023;
        BIN: Record 7302;
        GETBin: Page 7379;
    begin
        ILine.SETRANGE(ILine."Document No.", Rec."Document No.");
        ILine.SETRANGE(ILine."No.", Rec."No.");
        IF ILine.FINDFIRST THEN BEGIN
            BIN.RESET;
            BIN.SETRANGE(BIN."Item No.", ILine."No.");
            GETBin.SETTABLEVIEW(BIN);
            GETBin.LOOKUPMODE := TRUE;
        END;
        GETBin.EDITABLE(FALSE);
        GETBin.RUN;
    end;

    local procedure QuantityPOQtyOnAfterValidate();
    begin
        MESSAGE('%1', 'T')
    end;

    // local procedure CloseOnPush();
    // begin
    //     IF Rec.Close = FALSE THEN
    //         EXIT
    //     ELSE BEGIN
    //         Ok := CONFIRM('Do you want to Close?');
    //         IF Ok = TRUE THEN BEGIN
    //             Rec.Close := TRUE;
    //             Rec."Close UserID" := USERID;
    //             Rec.MODIFY;
    //         END ELSE
    //             Rec.Close := FALSE;
    //         Rec.MODIFY;
    //     END;
    // end;

    local procedure LookupOKOnPush();
    begin
        IF (Rec.Quantity - Rec."PO Qty") <> 0 THEN BEGIN
            CurrPage.SETSELECTIONFILTER(Rec);
            SetPurchHeaderIndent(PurchHeader);
            CreateIndentLines(Rec);
        END ELSE BEGIN
            ERROR('%1', 'Please select the records having Outstanding Qty');
        END;
    end;
}

