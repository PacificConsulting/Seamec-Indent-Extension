page 50096 "RFQ Catalogs WS"
{
    //PCPL/0070 14Feb2023 
    //
    Caption = 'Quotation Received WS';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RFQ Catalog";
    Editable = true;
    SourceTableView = sorting(Price) order(ascending) where("Sequence No." = filter(0));


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Item Details"; Rec."Item Details")
                {
                    Description = 'PCPL-25/180723';
                }
                field(UOM; Rec.UOM)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        RFQC: Record "RFQ Catalog";
                    Begin
                        RFQC.Reset();
                        RFQC.SetRange("Document No.", Rec."Document No.");
                        RFQC.SetRange("Item No.", Rec."Item No.");
                        if RFQC.FindSet() then
                            repeat
                                IF (RFQC.Select = true) AND (Rec.Select = true) then
                                    Error('You can not select multiple lines');
                            until RFQC.Next() = 0;
                    End;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    // Editable = false;
                    TableRelation = Vendor;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.TestField("Vendor No.");
                    end;
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = all;
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = All;
                }
                field(Currency; Rec.Currency)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount LCY"; Rec."Total Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Quotation Submited on"; Rec."Quotation Submited on")
                {
                    ApplicationArea = All;
                    //Editable = false;
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    /*
        //PCPL-25/180723
        trigger OnAfterGetRecord()
        var
            recitem: Record Item;
        begin
            if recitem.Get(Rec."Item No.") then begin
                Rec."Item Details" := recitem."Item Details";
                Rec.Modify();
            end;
        end;
        //PCPL-25/180723
        */

    trigger OnClosePage()
    var
    Begin

    End;

    var
    //myInt: Record 37; 
}