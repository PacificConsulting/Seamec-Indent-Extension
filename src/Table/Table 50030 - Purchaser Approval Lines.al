table 50030 "Purchaser Approval Lines"
{
    // version RSPL/INDENT/V3/001

    // Author        Code      Documentation
    // Venkatesh     VK001     To print Description of variant code
    // Nandesh       NG001     To List Items according to category selected on Indent Header


    fields
    {
        field(50101; "Entry No"; Integer)
        {
        }
        field(50103; "Line No."; Integer)
        {
            Editable = false;
        }
        field(50104; Date; Date)
        {
            TableRelation = "Indent Header".Date;
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
        }
        field(50107; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
        }
        field(50108; Quantity; Decimal)
        {
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
        field(50122; Remark; Text[250])
        {
        }
        field(50123; "USER ID"; Text[30])
        {
            Editable = false;
        }
        field(50124; "FA Component Category"; Code[20])
        {
            //TableRelation = test3.test;
        }
        field(50125; "Requirement Date"; Date)
        {
        }
        field(50126; "Product Group Code"; Code[20])
        {
            TableRelation = "Product Group".Code;
        }
        field(50127; "Item Category Code"; Code[10])
        {
        }
        field(50128; Category; Option)
        {
            OptionCaption = '" ,Engineering,Raw Materials,Lab Equipment,Lab Chemicals,Packing Material,,Safety,Production,Information Technology (IT)"';
            OptionMembers = " ",Engineering,"Raw Materials","Lab Equipment","Lab Chemicals","Packing Material",,Safety,Production,"Information Technology (IT)";
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
        field(50142; "Vendor Unit_ Price"; Decimal)
        {
            Description = '//PCPL/BRB/Portal';
        }
        field(50143; "Vendor Discount %"; Decimal)
        {
            Description = '//PCPL/BRB/Portal';
        }
        field(50144; "Lead Time"; Time)
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
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
        key(Key2; "Location Code", "No.")
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
        "USER ID" := USERID;
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
}

