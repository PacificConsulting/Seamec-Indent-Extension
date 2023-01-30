table 50022 "Indent Header"
{
    // version RSPL/INDENT/V3/001,PCPL-FA-1.0,PCPL-25/INCDoc,PCPL-JOB0001

    // //001 - to get no series by default
    // //002 - to insert userid & creation date


    fields
    {
        field(50101; "Entry Type"; Option)
        {
            OptionCaption = 'Indent,Posted Indent';
            OptionMembers = Indent,"Posted Indent";
        }
        field(50102; "No."; Code[20])
        {
            //This property is currently not supported
            // TestTableRelation = true;
            //ValidateTableRelation = true;


            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    PurchSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
        field(50103; Date; Date)
        {
        }
        field(50104; "Created By"; Code[50])
        {
            Description = 'change from 20 to 50 Testing';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(50105; "Creation Date"; Date)
        {
        }
        field(50106; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50107; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50109; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50110; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(50111; "Total Qty"; Decimal)
        {
            CalcFormula = Sum("Indent Line".Quantity WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(50112; Category; Option)
        {
            OptionCaption = '" ,Engineering,Raw Materials,Lab Equipment,Lab Chemicals,Packing Material,Safety,Production,Information Technology,Bldg. No1,Bldg No.2,Bldg No.3,QA,Warehouse,SRP,ETP & MEE,Utility,Formulation,Stationary,API block,Warehouse Block,Administration,QC & QA,UG water Storage Tank,UG solvent storage Tank farm,Intermediate Block,Hydrogenation Block,Utility Block-1,Utility Block-2,Distillation block,Road drainages & compound wall,EHS,Transformer yard,Security Cabin"';
            OptionMembers = " ",Engineering,"Raw Materials","Lab Equipment","Lab Chemicals","Packing Material",Safety,Production,"Information Technology","Bldg. No1","Bldg No.2","Bldg No.3",QA,Warehouse,SRP,"ETP & MEE",Utility,Formulation,Stationary,"API block","Warehouse Block",Administration,"QC & QA","UG water Storage Tank","UG solvent storage Tank farm","Intermediate Block","Hydrogenation Block","Utility Block-1","Utility Block-2","Distillation block","Road drainages & compound wall",EHS,"Transformer yard","Security Cabin";
        }
        // field(50113; Purpose; Option) //Indent Header Purpose Master
        // {
        //     OptionCaption = '" ,Project,Maintenance,Production,Quality Control,Research and Devolopment,Electrical,Instrument,Civil,Upgradation"';
        //     OptionMembers = " ",Project,Maintenance,Production,"Quality Control","Research and Devolopment",Electrical,Instrument,Civil,Upgradation;
        // }
        field(50113; Purpose; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header Purpose Master".Name;
        }
        field(50114; Status; Option)
        {
            OptionMembers = Open,Released,Closed,"Pending For Approval","First Approval";//,Approved;
            OptionCaption = 'Open,Released,Closed,Pending For Approval,First Approval';//,Approved';

        }
        field(50115; "Release User ID"; Code[50])
        {
            Description = 'change from 20 to 50 Testing';
            Editable = false;
            TableRelation = User;
        }
        field(50116; "Material category"; Code[10])
        {
            TableRelation = "Item Category".Code;
        }
        field(50117; "Closed By"; Code[50])
        {
            Description = 'Sanjay 30/01/2015';
            TableRelation = User;
        }
        field(50118; "Closed Date"; Date)
        {
            Description = 'Sanjay 30/01/2015';
        }
        field(50119; "Job Maintenance No."; Code[20])
        {
            Description = '//PCPL-FA-1.0';
        }
        field(50120; "Incoming Document Entry No."; Integer)
        {
            Description = 'PCPL-25/INCDoc';
        }
        field(50121; "Job No."; Code[20])
        {
            AccessByPermission = TableData 167 = R;
            Description = 'PCPL-JOB0001';

            trigger OnLookup();
            var
                JobPlanningLine: Record 1003;
            begin
            end;

            trigger OnValidate();
            var
                JobPlanningLine: Record 1003;
            begin
            end;
        }
        field(50122; "Job Task No."; Code[10])
        {
            Description = 'PCPL-JOB0001';
        }
        field(50123; "Type of Indent"; Option)
        {
            OptionMembers = " ",Emergency,Routine;
            OptionCaption = ' ,Emergency,Routine';
            Description = 'PCPL-0070';
        }
        field(50124; "First Approver"; DateTime)
        {
            Description = 'PCPL-0070';
        }
        field(50125; "Second Approver"; DateTime)
        {
            Description = 'PCPL-0070';
        }
        field(50126; "Approver ID"; code[50])
        {
            Editable = false;
            Description = 'PCPL-0070';
        }
    }

    keys
    {
        key(Key1; "No.", "Entry Type")
        {
        }
        key(Key2; "Entry Type", "No.")
        {
        }
        key(Key3; "Location Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin

        //001
        PurchSetup.GET;
        //Abhinav----Start
        IF "No." = '' THEN BEGIN
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", Date, "No.", "No. Series");
        END;


        //Abhinav----End
        //001
        ReqWork.RESET;
        ReqWork."Entry no" := "No.";
        //002
        "Created By" := USERID;
        "Creation Date" := WORKDATE;
        //002
        //
        //"Closed By":=USERID;
        //"Closed Date":=WORKDATE;
        //
        Date := WORKDATE;
        "Entry Type" := "Entry Type"::Indent;
    end;


    local procedure TestNoSeries(): Boolean;
    begin
        CASE "Entry Type" OF
            "Entry Type"::Indent:
                PurchSetup.TESTFIELD("Order Nos.");

        END;
    end;

    local procedure GetNoSeriesCode(): Code[10];
    var
        NoSeries: Record 308;
        NoSeriesRelation: Record 310;
    begin

        CASE "Entry Type" OF
            "Entry Type"::Indent:
                EXIT(PurchSetup."Indent No.");
        END;
    end;

    procedure AssistEdit(OldIndentHeader: Record 50022): Boolean;
    begin
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldIndentHeader."No. Series", "No. Series") THEN BEGIN
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;


    var
        Noseriesrelation: Record 310;
        PurchSetup: Record 312;
        NoSeriesMgt: Codeunit 396;
        ReqWork: Record 246;
        RecRec: Page 291;

}

