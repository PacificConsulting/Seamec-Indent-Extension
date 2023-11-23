table 50028 "Purchaser Approvals Lines"
{
    // version RSPL/INDENT/V3/001

    // Author        Code      Documentation
    // Venkatesh     VK001     To print Description of variant code
    // Nandesh       NG001     To List Items according to category selected on Indent Header


    fields
    {
        field(50101; "Entry Type"; Option)
        {
            OptionCaption = 'Indent,Posted Indent';
            OptionMembers = Indent,"Posted Indent";
        }
        field(50102; "Document No."; Code[20])
        {
            TableRelation = "Indent Header"."No." WHERE("Entry Type" = FIELD("Entry Type"));
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(50103; "Line No."; Integer)
        {
            Editable = false;
        }
        field(50104; Date; Date)
        {
            TableRelation = "Indent Header".Date;

            trigger OnValidate();
            begin
                TestApprove();
            end;
        }
        field(50105; Type; Option)
        {
            OptionCaption = '" ,G/L Account,Item,,Fixed Asset"';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(50106; "No."; Code[20])
        {
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";

            trigger OnValidate();
            begin

                TestApprove();
                IF indentheader.GET("Document No.") THEN
                    "Location Code" := indentheader."Location Code";



                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET("No.");
                            GLAcc.CheckGLAcc;
                            Description := GLAcc.Name;
                            "Unit of Measure Code" := '';
                            "Item Category Code" := GLAcc."Gen. Prod. Posting Group";
                            Category := indentheader.Category;
                            //     indentheader.TESTFIELD(indentheader."Material category");
                            //      indentheader.TESTFIELD(indentheader.Purpose);

                        END;



                    Type::Item:
                        BEGIN
                            TESTFIELD("No.");
                            Item.GET("No.");
                            Item.TESTFIELD(Blocked, FALSE);
                            IF Item."Blocked Type" = Item."Blocked Type"::Indent THEN
                                ERROR('Blocked Type must not be Indent for this Item');

                            Item.TESTFIELD("Inventory Posting Group");
                            Item.TESTFIELD("Gen. Prod. Posting Group");
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                            "Unit of Measure Code" := Item."Base Unit of Measure";
                            "Item Category Code" := Item."Item Category Code";
                            Category := indentheader.Category;
                            indentheader.TESTFIELD(indentheader."Material category");
                            indentheader.TESTFIELD(indentheader.Purpose);
                        END;

                    Type::"Fixed Asset":
                        BEGIN
                            FA.GET("No.");
                            FA.TESTFIELD(Inactive, FALSE);
                            FA.TESTFIELD(Blocked, FALSE);
                            IF FA."Blocked Type" = Item."Blocked Type"::Indent THEN
                                ERROR('Blocked Type must not be Indent for this Fixed Asset');

                            // FA.TESTFIELD("Gen. Prod. Posting Group"); //PCPL-0070
                            Description := FA.Description;
                            "Description 2" := FA."Description 2";
                            "Unit of Measure Code" := '';
                            "Item Category Code" := indentheader."Material category";
                            Category := indentheader.Category;
                            //         indentheader.TESTFIELD(indentheader."Material category");
                            //    indentheader.TESTFIELD(indentheader.Purpose);

                        END;

                END;
            end;
        }
        field(50107; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;

            trigger OnValidate();
            begin
                TestApprove();
            end;
        }
        field(50108; Quantity; Decimal)
        {

            trigger OnValidate();
            begin
                TestApprove();
                VALIDATE("PO Qty");
            end;
        }
        field(50110; "PO Qty"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Quantity WHERE("Indent No." = FIELD("Document No."),
                                                              "Location Code" = FIELD("Location Code"),
                                                              "No." = FIELD("No."),
                                                              "Indent Line No." = FIELD("Line No.")));
            Editable = true;
            FieldClass = FlowField;
        }
        field(50111; Approved; Boolean)
        {

            trigger OnValidate();
            begin

                IF Approved = TRUE THEN BEGIN
                    IF ("Location Code" = '') THEN
                        ERROR('%1', 'Location Code should not be blank');
                    IF (Quantity = 0) THEN
                        ERROR('%1', 'Quanity should not 0');
                END;

                IF Approved = TRUE THEN
                    TESTFIELD("Requirement Date");


                IF Approved = TRUE THEN
                    "Approved Date" := WORKDATE;
            end;
        }
        field(50112; Description; Text[50])
        {
        }
        field(50113; "Description 2"; Text[50])
        {
        }
        field(50114; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate();
            var
                UnitOfMeasureTranslation: Record 5402;
            begin
            end;
        }
        field(50115; "Requisition Line No."; Integer)
        {
        }
        field(50116; "Requisition Templet Name"; Code[30])
        {
        }
        field(50117; "Requisition Batch Name"; Code[30])
        {
        }
        field(50118; "Outstanding True"; Boolean)
        {
        }
        field(50119; Close; Boolean)
        {

            trigger OnValidate();
            begin
                IF Close = TRUE THEN
                    "Close UserID" := USERID;
            end;
        }
        field(50120; "Description 3"; Text[60])
        {
        }
        field(50121; "Material Requisitioned"; Text[50])
        {
        }
        field(50122; Remark; Text[250])
        {
        }
        field(50123; "USER ID"; Text[30])
        {
            Editable = false;
        }
        field(50124; "FA Component Category"; Code[20])
        {
            //   TableRelation = test3.test;
        }
        field(50125; "Requirement Date"; Date)
        {
        }
        field(50126; "Product Group Code"; Code[20])
        {
            //TableRelation = "Product Group".Code;  //PCPL-25/031023 comment becuase remove Product Group table
        }
        field(50127; "Item Category Code"; Code[10])
        {
        }
        field(50128; Category; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50129; "Variant Code"; Code[10])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate();
            begin

                //VK001-BEGIN
                IF "Variant Code" <> '' THEN
                    RecVar.SETRANGE(RecVar."Item No.", "No.");
                RecVar.SETRANGE(RecVar.Code, "Variant Code");
                IF RecVar.FINDFIRST THEN
                    Description := RecVar.Description
                ELSE
                    IF Item.GET("No.") THEN
                        Description := Item.Description;

                //VK001-END
            end;
        }
        field(50130; "Approved Date"; Date)
        {
            Editable = true;
        }
        field(50131; Status; Boolean)
        {

            trigger OnValidate();
            begin

                IF Status = TRUE THEN
                    "Releaser User ID" := USERID;
                "Release Date and Time" := CURRENTDATETIME;
                MODIFY;
            end;
        }
        field(50132; "Approved By"; Code[50])
        {
            Editable = false;
        }
        field(50133; "Cost Allocation Dimension"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('CA'));
        }
        field(50134; "Release Date and Time"; DateTime)
        {
        }
        field(50135; "Releaser User ID"; Code[50])
        {
        }
        field(50136; "Approved Date and Time"; DateTime)
        {
        }
        field(50137; "End Use"; Text[50])
        {

            trigger OnLookup();
            begin
                FSC.RESET;
                IF PAGE.RUNMODAL(0, FSC) = ACTION::LookupOK THEN
                    "End Use" := FSC.Name;
            end;
        }
        field(50139; "Close UserID"; Code[50])
        {
        }
        field(50140; "Comment for Close"; Text[100])
        {
        }
        field(50141; Closingqty; Decimal)
        {
            CalcFormula = Sum("Warehouse Entry"."Qty. (Base)" WHERE("Location Code" = FIELD("Location Code"),
                                                                     "Item No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50142; "Vendor Unit_ Price"; Decimal)
        {
            Description = '//PCPL/BRB/Portal';
        }
        field(50143; "Vendor Discount %"; Decimal)
        {
            Description = '//PCPL/BRB/Portal';
        }
        field(50144; "Lead Time"; Text[30])
        {
            Description = '//PCPL/BRB/Portal';
        }
        field(50145; Availability; Text[60])
        {
        }
        field(50146; "Self Life"; Text[60])
        {
        }
        field(50147; Observation; Text[60])
        {
        }
        field(50148; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF Vend.GET("Vendor No.") THEN
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(50149; "Vendor Name"; Text[60])
        {
        }
        field(50150; Selected; Boolean)
        {
        }
        field(50151; "Mail Already Sent"; Boolean)
        {
        }
        field(50152; "Entry No"; Integer)
        {
        }
        field(50153; "PO Status"; Option)
        {
            OptionCaption = 'Open,Close,Revised';
            OptionMembers = Open,Close,Revised;
        }
        field(50154; "Quotation Qty"; Decimal)
        {
        }
        field(50155; "Indent Closing Date"; Date)
        {
            Description = 'pcpl002430oct';
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //TestApprove();
    end;

    trigger OnInsert();
    begin
        indentline.SETRANGE(indentline."Entry Type", "Entry Type");
        indentline.SETRANGE(indentline."Document No.", "Document No.");
        IF indentline.FINDLAST THEN BEGIN
            "Line No." := indentline."Line No." + 10000;
        END ELSE BEGIN
            "Line No." := 10000
        END;

        //to get date
        indentheader.GET("Document No.");
        indentheader.TESTFIELD(indentheader.Date);
        Rec.Date := indentheader.Date;
        "Location Code" := indentheader."Location Code";
        "USER ID" := USERID;
    end;

    trigger OnModify();
    begin
        VALIDATE(Approved)
    end;

    var
        indentheader: Record 50022;
        indentline: Record 50023;
        Item: Record 27;
        GLAcc: Record 15;
        FA: Record 5600;
        Text000: Label 'Indnet No. %1:';
        Text001: Label 'The program cannot find this purchase line.';
        NextLineNo: Integer;
        indentline1: Record 50023;
        outstandqty: Decimal;
        Des: Decimal;
        PurchaseLinesForm: Page "Purchase Lines";
        RecVar: Record 5401;
        IH: Record 50022;
        ITM: Record 27;
        GL: Record 15;
        RFA: Record 5600;
        FSC: Record 5608;
        Vend: Record 23;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        DimMgt: Codeunit 408;
    begin
        /*DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        IF "Line No." <> 0 THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::Indent,0,"Document No.",
            "Line No.",FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
        */

    end;

    local procedure TestApprove();
    begin
        IF Approved = TRUE THEN
            ERROR('%1%2', 'No Change in Line for line No', "Line No.");
    end;

    local procedure GetIndentHeader();
    begin
        TESTFIELD("Document No.");
    end;

    procedure InsertPurchLineFromIndentLine(var PurchLine: Record 39);
    var
        PurchInvHeader: Record 38;
        PurchOrderHeader: Record 38;
        PurchOrderLine: Record 39;
        TempPurchLine: Record 39;
        PurchSetup: Record 312;
        TransferOldExtLines: Codeunit 379;
        ItemTrackingMgt: Codeunit 6500;
        NextLineNo: Integer;
        ExtTextLine: Boolean;
        "**sh": Integer;
        IndentPO: Record 50025;
    begin
        SETRANGE("Document No.", "Document No.");

        TempPurchLine := PurchLine;
        IF PurchLine.FIND('+') THEN
            NextLineNo := PurchLine."Line No." + 10000
        ELSE
            NextLineNo := 10000;

        IndentPO.RESET;
        IndentPO.SETFILTER(IndentPO."Document No.", "Document No.");
        IndentPO.SETRANGE(IndentPO."PO Line No.", "Line No.");
        IndentPO.SETRANGE(IndentPO.Type, Type);
        IndentPO.SETFILTER(IndentPO."No.", "No.");
        IndentPO.SETFILTER(IndentPO."Location Code", "Location Code");
        IF IndentPO.FINDFIRST THEN
            REPEAT
                "PO Qty" += IndentPO."P.O.Qty";
            UNTIL IndentPO.NEXT = 0;


        IF PurchInvHeader."No." <> TempPurchLine."Document No." THEN
            PurchInvHeader.GET(TempPurchLine."Document Type", TempPurchLine."Document No.");

        PurchLine.INIT;
        REPEAT
            PurchLine."Line No." := NextLineNo;
            PurchLine."Document Type" := TempPurchLine."Document Type";
            PurchLine."Document No." := TempPurchLine."Document No.";
            PurchLine.Type := Type;
            PurchLine.VALIDATE(PurchLine."No.", "No.");
            PurchLine.Description := Description;
            PurchLine."Description 2" := "Description 2";
            //PurchLine."Description 3"        :=   "Description 3";
            //      PurchLine.VALIDATE(PurchLine."Unit of Measure Code",  "Unit of Measure Code") ;
            PurchLine."Unit of Measure Code" := "Unit of Measure Code";
            PurchLine."Location Code" := "Location Code";
            PurchLine."Material Requisition" := "Material Requisitioned";
            PurchLine."FA Component Category" := "FA Component Category";
            PurchLine."Variant Code" := "Variant Code"; // VK
                                                        //CALCSUMS("PO Qty");
            CALCFIELDS("PO Qty");
            outstandqty := Quantity - "PO Qty";
            PurchLine.VALIDATE(PurchLine.Quantity, outstandqty); // Tolerance System
            PurchLine."Indent No." := "Document No.";
            PurchLine.VALIDATE(PurchLine."Indent Line No.", "Line No.");
            IF outstandqty <> 0 THEN BEGIN
                PurchLine.INSERT;
                /* //need to check dimension in nav13
                //
                DocDim.RESET;
                DocDim.SETRANGE(DocDim."Document Type",DocDim."Document Type"::Order);
                DocDim.SETRANGE(DocDim."Document No.",PurchLine."Document No.");
                DocDim.SETRANGE(DocDim."Line No.",PurchLine."Line No.");
                DocDim.SETRANGE("Dimension Code",'CA');
                  IF NOT DocDim.FINDFIRST THEN BEGIN
                  DocDim.INIT;
                  DocDim."Table ID" := 39;
                  DocDim."Document Type" := DocDim."Document Type"::Order;
                  DocDim."Document No." := PurchLine."Document No.";
                  DocDim."Line No." := PurchLine."Line No.";
                  DocDim."Dimension Code" := 'CA';
                  DocDim."Dimension Value Code" := PurchLine."Cost Allocation Dimension";
                  DocDim.INSERT;
                  END
                  */
            END ELSE BEGIN
                EXIT;
            END;

            NextLineNo := NextLineNo + 10000;
        UNTIL PurchLine.NEXT = 0;

    end;

    procedure ShowLineComments();
    var
        ScheduleDetail: Record 50021;
        ScheduleForm: Page 50068;
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        ScheduleDetail.SETRANGE(ScheduleDetail."Entry Type", "Entry Type");
        ScheduleDetail.SETRANGE(ScheduleDetail."Document No", "Document No.");
        ScheduleDetail.SETRANGE(ScheduleDetail."Indent Line No", "Line No.");
        ScheduleDetail.SETRANGE(ScheduleDetail.type, Type);
        ScheduleDetail.SETRANGE(ScheduleDetail.Item, "No.");
        ScheduleForm.SETTABLEVIEW(ScheduleDetail);
        ScheduleForm.RUNMODAL;
    end;
}

