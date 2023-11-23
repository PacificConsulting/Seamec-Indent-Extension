page 50067 "Indent-Purchase Order"
{
    // version RSPL/INDENT/V3/001
    Caption = 'Indent Purchase Action';
    PageType = List;
    SourceTable = 50023;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTableView = where("Header Status" = filter('Released'), Generate = filter(false));
    Editable = true;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    Editable = true;
                    trigger OnValidate()
                    begin
                        if Rec.Generate = true then
                            Error('RFQ already generated');
                        IF Rec."Indent Type" = Rec."Indent Type"::Service then
                            Error('User can''t select this document no. because indent type is service');
                    end;
                }
                field(Generate; Rec.Generate)
                {
                    ApplicationArea = All;
                    Caption = 'RFQ Generated';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        indentheader: Record "Indent Header";
                    begin
                        if indentheader.Get(Rec."Document No.") then;
                        indentheader.TestField(Status, indentheader.Status::Open);
                    end;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        indentheader: Record "Indent Header";
                    begin
                        if indentheader.Get(Rec."Document No.") then;
                        indentheader.TestField(Status, indentheader.Status::Open);
                    end;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Requisition Line No."; Rec."Requisition Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Requisition Templet Name"; Rec."Requisition Templet Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Requisition Batch Name"; Rec."Requisition Batch Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Outstanding True"; Rec."Outstanding True")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                // field(Close; Rec.Close)
                // {
                //     ApplicationArea = all;
                //     Editable = false;
                // }
                field("Description 3"; Rec."Description 3")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Material Requisitioned"; Rec."Material Requisitioned")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("FA Component Category"; Rec."FA Component Category")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Requirement Date"; Rec."Requirement Date")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateRFQ)
            {
                Caption = 'Create RFQ';
                Promoted = true;
                PromotedCategory = Process;
                Image = Open;
                //RunObject = page 50089;
                //PCPL/0070 15Feb2023 <<
                trigger OnAction()
                var
                    IndentLine: Record 50023;
                    RFQHdr: Record "RFQ Header";
                    RFQLine: Record "RFQ Line";
                    LineNo: Integer;
                    IndentHdr: Record "Indent Header";
                begin
                    if Rec.Select = true then begin
                        IndentLine.Reset();
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        IndentLine.SetRange(Select, true);
                        if IndentLine.FindFirst() then begin
                            RFQHdr.Init();
                            RFQHdr.Validate("No.", Rec."Document No.");
                            RFQHdr.Validate(Date, Rec.Date);
                            RFQHdr.Validate("Location Code", Rec."Location Code");
                            RFQHdr.Validate("USER ID", Rec."USER ID");
                            RFQHdr.Validate(Category, Rec.Category);
                            IF IndentHdr.Get(Rec."Document No.") then;
                            RFQHdr."Job Maintenance No." := IndentHdr."Job Maintenance No.";
                            RFQHdr.Insert();
                            //Message('RFQ Hdr %1 has been created', RFQHdr."Document No.");
                        End;
                        IndentLine.Reset();
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        //IndentLine.SetRange(Select, true);
                        if IndentLine.FindSet() then begin
                            LineNo := 10000;
                            repeat
                                RFQLine.Init();
                                RFQLine.Validate("Document No.", RFQHdr."No.");
                                RFQLine.Validate("Line No.", LineNo);
                                RFQLine.Validate("No.", IndentLine."No.");
                                RFQLine.Validate(Type, IndentLine.Type);
                                RFQLine.Validate("Unit of Measure Code", IndentLine."Unit of Measure Code");
                                RFQLine.Validate(Quantity, IndentLine.Quantity);
                                RFQLine.Validate("PO Qty", IndentLine."PO Qty");
                                RFQLine.Validate(Description, IndentLine.Description);
                                RFQLine.Validate("Description 2", IndentLine."Description 2");
                                RFQLine.Validate("Description 3", IndentLine."Description 3");
                                RFQLine.Validate(Remark, IndentLine.Remark);
                                RFQLine.Validate(Comment, IndentLine.Comment);
                                RFQLine.Validate("Location Code", RFQHdr."Location Code");
                                LineNo += 10000;
                                RFQLine.Insert();
                                IndentLine.Generate := true;
                                IndentLine.Modify();
                            until IndentLine.Next() = 0;
                            Message('RFQ Order %1 has been Created', RFQHdr."No.");
                        end;
                        Page.Run(50089);
                    end else
                        Page.Run(50089);
                End;
                //PCPL/0070 15Feb2023 >>
            }
        }
    }

    trigger OnOpenPage();
    var
        RecUser: Record 91;
        TmpLocCode: Code[100];
    begin
        //PCPL0041-13022020-Start
        //FILTERGROUP(2);
        //SETFILTER("PO Qty",'%1',0);
        //FILTERGROUP(0);
        //PCPL0041-13022020-End

        //PCPL0017
        //RecUser.RESET;
        //RecUser.SETRANGE(RecUser."User ID",USERID);

        //IF RecUser.FINDFIRST THEN
        //BEGIN
        //TmpLocCode := RecUser."Location Code";
        //END;
        //IF TmpLocCode <> '' THEN
        //BEGIN
        //FILTERGROUP(2);
        //SETFILTER("Location Code",TmpLocCode);
        //FILTERGROUP(0);
        //END;
        //PCPL0017
        CurrPage.Editable(true);

        //PCPL-25/060723
        RecUser.RESET;
        RecUser.SETRANGE(RecUser."User ID", USERID);
        IF RecUser.FINDFIRST THEN BEGIN
            TmpLocCode := RecUser."Location Code";
        END;

        IF TmpLocCode <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETFILTER("Location Code", TmpLocCode);
            Rec.FILTERGROUP(0);
        END;
        //PCPL-25/060723
    end;

    //PCPL-0070 21Mar23 <<
    trigger OnAfterGetRecord()
    var
        IndentHdr: Record "Indent Header";
    Begin
        IF IndentHdr.Get(Rec."Document No.") then
            Rec.Category := IndentHdr.Category;
    End;
    //PCPL-0070 21Mar23 >>
}

