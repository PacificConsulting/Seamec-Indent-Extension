table 50020 "RFQ Header"
{
    //--PCPL/0070/13Feb2023
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
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

            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("RFQ Line"."Total Amount LCY" where("Document No." = field("No.")));
        }
        field(6; Status; Option)
        {
            OptionCaption = 'Open,Released,Cancelled';
            OptionMembers = Open,Released,Cancelled;
        }
        field(7; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open,"Pending Approval",Released;
            Caption = 'Approval Status';
        }
        field(8; Category; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Requistion Purchase Category";
        }
        field(9; "Created PO"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Cost Center';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Project Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(12; "Job Maintenance No."; Code[20])
        {
            Description = '//PCPL-FA-1.0';
            TableRelation = "PMS JOB Header" where(Status = filter(Open));
        }
        field(13; IsQuotationSumbit; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(14; "PO Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064';
        }
    }

    keys
    {
        key(Key1; "No.")
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