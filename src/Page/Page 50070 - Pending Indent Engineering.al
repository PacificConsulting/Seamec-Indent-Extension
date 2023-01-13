page 50118 "Pending Indent Engineering"
{
    // version RSPL/INDENT/V3/001

    PageType = List;
    SourceTable = 50023;
    SourceTableView = WHERE(Close = FILTER(false),
                            "PO Qty" = FILTER(0),
                            Category = FILTER(Engineering));
    ApplicationArea = all;
    UsageCategory = Lists;


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

