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
            trigger OnValidate()
            var
                Item_Rec: Record Item;
            begin
                if Item_Rec.GET("Item No.") then
                    Description := Item_Rec.Description;

            end;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
                if Vend.GET("Vendor No.") then
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(5; Price; Decimal)
        {
            DataClassification = ToBeClassified;
            //PCPL-25/240323
            trigger OnValidate()
            begin
                "Total Amount" := Quantity * Price;
                "Total Amount LCY" := "Total Amount";
            end;
            //PCPL-25/240323
        }
        field(6; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Select; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; Remarks; Text[2048])
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
        field(13; "Quotation Submited on"; DateTime)
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            Description = '28Mar2023';
        }
        field(14; "Sequence No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Description = '28Mar2023';
        }
        field(15; Currency; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '29Mar2023';
            trigger OnValidate()
            var
                CurrExRate: Record "Currency Exchange Rate";
                Date1: Date;
            begin
                Date1 := DT2Date("Quotation Submited on");
                CurrExRate.Reset();
                CurrExRate.SetRange("Currency Code", Rec.Currency);
                CurrExRate.SetRange("Starting Date", Date1);
                if CurrExRate.FindFirst() then
                    Rec."Total Amount LCY" := Rec."Total Amount" * CurrExRate."Relational Exch. Rate Amount"
                else begin
                    CurrExRate.Reset();
                    CurrExRate.SetRange("Currency Code", rec.Currency);
                    if CurrExRate.FindLast() then
                        Rec."Total Amount LCY" := Rec."Total Amount" * CurrExRate."Relational Exch. Rate Amount"
                end;

                if Rec."Total Amount LCY" = 0 then
                    Rec."Total Amount LCY" := "Total Amount";
            end;
        }
        field(19; "Total Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Description = '29Mar2023';
        }
        field(20; "GST Group Code"; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = '29Mar2023';
            TableRelation = "GST Group";
        }
        field(21; "Vendor Name"; text[50])
        {
            DataClassification = ToBeClassified;
            Description = '26Apr2023';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Item No.", "Vendor No.", "Line No.", "Sequence No.")
        {
            Clustered = true;
        }
        key(Key2; Price, "Vendor No.")
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