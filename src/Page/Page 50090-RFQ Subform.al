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
    // ApplicationArea = All;
    // UsageCategory = Administration;
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
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; Rec."Line Amount")
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
                    RFQ_C: Record "RFQ Catalog";
                begin
                    RFQ_C.SetRange("Document No.", Rec."Document No.");
                    RFQ_C.SetRange("Item No.", Rec."No.");
                    if RFQ_C.FindSet() then begin
                        if Page.RunModal(50092, RFQ_C) = Action::LookupOK then begin
                            if RFQ_C.Select = true then begin
                                Rec."Vendor No." := RFQ_C."Vendor No.";
                                Rec."Unit Cost" := RFQ_C.Price;
                                Rec."Line Amount" := Rec.Quantity * rec."Unit Cost";
                                Rec."Vendor No." := RFQ_C."Vendor No.";
                                Rec.Modify();
                                CurrPage.Update();
                            end Else begin
                                if RFQ_C.Select = false then begin
                                    RFQ_C.SetCurrentKey(Price);
                                    if RFQ_C.FindFirst() then begin
                                        Rec."Vendor No." := RFQ_C."Vendor No.";
                                        Rec."Unit Cost" := RFQ_C.Price;
                                        Rec."Line Amount" := Rec.Quantity * rec."Unit Cost";
                                        Rec."Vendor No." := RFQ_C."Vendor No.";
                                        Rec.Modify();
                                        CurrPage.Update();
                                    end;
                                end;
                            end;
                        end;
                    End Else
                        Error('Please Insert Record in Quotation Receive Page')
                end;
            }
            action(Insert)
            {
                ApplicationArea = All;
                Caption = 'Insert Vendor Catlog';
                Image = Insert;
                trigger OnAction()
                var
                    ItemVend: Record "Item Vendor";
                    RFQCatalog: Record "RFQ Catalog";
                    LineNo: Integer;
                Begin
                    ItemVend.Reset();
                    ItemVend.SetRange("Item No.", Rec."No.");
                    if ItemVend.FindSet() then begin
                        repeat
                            RFQCatalog.Reset();
                            RFQCatalog.SetRange("Document No.", Rec."Document No.");
                            RFQCatalog.SetRange("Vendor No.", ItemVend."Vendor No.");
                            if not RFQCatalog.FindFirst() then begin
                                RFQCatalog.Init();
                                RFQCatalog.Validate("Document No.", Rec."Document No.");
                                RFQCatalog.Validate("Line No.", Rec."Line No.");
                                RFQCatalog.Validate("Vendor No.", ItemVend."Vendor No.");
                                RFQCatalog.Validate("Item No.", ItemVend."Vendor Item No.");
                                RFQCatalog.Validate(Quantity, Rec.Quantity);
                                RFQCatalog.Insert();
                            End;
                        until ItemVend.Next() = 0;
                    End Else
                        Error('Vendor catalog does not exist');
                End;
            }
        }
    }

    var
        myInt: Record 38;
}