table 50018 "RFQ Catalog"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Price; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Remarks; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(9; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(10; UOM; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Comment; Text[230])
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
        field(12; "Total Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = False;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Item No.", "Vendor No.")
        {
            Clustered = true;
        }
        key(Key2; Price)
        {

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