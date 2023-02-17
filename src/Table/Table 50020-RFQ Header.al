table 50020 "RFQ Header"
{
    //--PCPL/0070/13Feb2023
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(4; "USER ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Total Amount"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("RFQ Line"."Line Amount" where("Document No." = field("Document No.")));
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Record 18;

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