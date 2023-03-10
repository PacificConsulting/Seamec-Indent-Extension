table 50019 "RFQ Line"
{
    //--PCPL/0070/13Feb2023
    DataClassification = ToBeClassified;
    Access = Public;
    Permissions = tabledata "RFQ Line" = RIMD;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Type; Option)
        {
            OptionCaption = '" ,G/L Account,Item,,Fixed Asset"';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF (Type = CONST(Item)) Item."No."
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"."No."
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset"."No.";
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
            DataClassification = ToBeClassified;
        }
        field(5; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "PO Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Description; Text[50])
        {
        }
        field(8; "Description 2"; Text[50])
        {
        }
        field(9; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
        }
        field(11; "Description 3"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(12; Remark; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Line Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}