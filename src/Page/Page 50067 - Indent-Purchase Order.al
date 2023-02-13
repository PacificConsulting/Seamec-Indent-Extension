page 50067 "Indent-Purchase Order"
{
    // version RSPL/INDENT/V3/001
    Caption = 'Indent Purchase Action';
    PageType = List;
    SourceTable = 50023;
    ApplicationArea = all;
    UsageCategory = Lists;
    SourceTableView = where("Header Status" = filter('Released'));


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = all;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
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
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = all;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field("Requisition Line No."; Rec."Requisition Line No.")
                {
                    ApplicationArea = all;
                }
                field("Requisition Templet Name"; Rec."Requisition Templet Name")
                {
                    ApplicationArea = all;
                }
                field("Requisition Batch Name"; Rec."Requisition Batch Name")
                {
                    ApplicationArea = all;
                }
                field("Outstanding True"; Rec."Outstanding True")
                {
                    ApplicationArea = all;
                }
                field(Close; Rec.Close)
                {
                    ApplicationArea = all;
                }
                field("Description 3"; Rec."Description 3")
                {
                    ApplicationArea = all;
                }
                field("Material Requisitioned"; Rec."Material Requisitioned")
                {
                    ApplicationArea = all;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = all;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = all;
                }
                field("FA Component Category"; Rec."FA Component Category")
                {
                    ApplicationArea = all;
                }
                field("Requirement Date"; Rec."Requirement Date")
                {
                    ApplicationArea = all;
                }
                field("Product Group Code"; Rec."Product Group Code")
                {
                    ApplicationArea = all;
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

                trigger OnAction()
                var
                    IndentLine: Record 50023;
                    RFQHdr: Record "RFQ Header";
                    RFQLine: Record "RFQ Line";
                    LineNo: Integer;
                begin
                    if Rec.Select = true then begin
                        IndentLine.Reset();
                        IndentLine.SetRange("Document No.", Rec."Document No.");
                        IndentLine.SetRange(Select, true);
                        if IndentLine.FindFirst() then begin
                            RFQHdr.Init();
                            RFQHdr.Validate("Document No.", Rec."Document No.");
                            RFQHdr.Validate(Date, Rec.Date);
                            RFQHdr.Validate("Location Code", Rec."Location Code");
                            RFQHdr.Validate("USER ID", Rec."USER ID");
                            RFQHdr.Insert();
                            Message('RFQ Hdr %1 has been created', RFQHdr."Document No.");
                        End;
                        IndentLine.Reset();
                        IndentLine.SetRange("Document No.", RFQHdr."Document No.");
                        IndentLine.SetRange(Select, true);
                        if IndentLine.FindSet() then begin
                            LineNo := 10000;
                            repeat
                                RFQLine.Init();
                                RFQLine.Validate("Document No.", RFQHdr."Document No.");
                                RFQLine.Validate("Line No.", LineNo);
                                RFQLine.Validate("No.", Rec."No.");
                                RFQLine.Validate(Type, Rec.Type);
                                RFQLine.Validate("Unit of Measure Code", Rec."Unit of Measure Code");
                                RFQLine.Validate(Quantity, Rec.Quantity);
                                RFQLine.Validate("PO Qty", Rec."PO Qty");
                                RFQLine.Validate(Description, Rec.Description);
                                RFQLine.Validate("Description 2", Rec."Description 2");
                                RFQLine.Validate("Description 3", Rec."Description 3");
                                RFQLine.Validate(Remark, Rec.Remark);
                                LineNo += 10000;
                                RFQLine.Insert();
                                Message('RFQ Lines Created');
                            until IndentLine.Next() = 0;
                        end;
                        Page.Run(50089);
                    end else
                        Page.Run(50089);
                End;

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
    end;
}

