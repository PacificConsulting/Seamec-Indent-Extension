page 50090 "RFQ Subform"
{
    //--PCPL/0070/13Feb2023
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = true;
    Editable = true;
    InsertAllowed = true;
    LinksAllowed = false;
    ModifyAllowed = true;
    MultipleNewLines = true;
    SaveValues = true;
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "RFQ Line";

    layout
    {
        area(Content)
        {
            repeater(control1)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {

                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("Description 3"; Rec."Description 3")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("PO Qty"; Rec."PO Qty")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field(Remark; Rec.Remark)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(QuotationList)
            {
                ApplicationArea = All;
                Caption = 'Quotation List';
                Image = Quote;
                trigger OnAction()
                var
                    ItemVend: Record "Item Vendor";
                    RFQCatalog: Record "RFQ Catalog";
                    LineNo: Integer;
                begin
                    if RFQCatalog.FindLast() then
                        LineNo := RFQCatalog."Line No." + 10000
                    else
                        LineNo := 10000;

                    ItemVend.Reset();
                    ItemVend.SetRange("Item No.", Rec."No.");
                    if ItemVend.FindSet() then
                        repeat
                            RFQCatalog.Init();
                            RFQCatalog.Validate("Document No.", Rec."Document No.");
                            RFQCatalog.Validate("Line No.", LineNo);
                            RFQCatalog.Validate("Vendor No.", ItemVend."Vendor No.");
                            RFQCatalog.Validate("Item No.", ItemVend."Vendor Item No.");
                            RFQCatalog.Insert();
                            LineNo += 10000;
                        until ItemVend.Next() = 0;
                    page.Run(50092);
                end;
            }
        }
    }

    var
        myInt: Integer;
}