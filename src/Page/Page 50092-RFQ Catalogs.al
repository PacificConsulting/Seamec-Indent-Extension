page 50092 "RFQ Catalogs"
{
    Caption = 'Quotation Received';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RFQ Catalog";
    Editable = true;
    SourceTableView = sorting(Price) order(ascending);

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
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Select; Rec.Select)
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    /*
     trigger OnClosePage()
     var
         RFQ: Record "RFQ Line";
         RFQ_C: Record "RFQ Catalog";
     begin
         RFQ_C.Reset();
         RFQ_C.SetRange("Document No.", Rec."Document No.");
         RFQ_C.SetRange("Item No.", Rec."Item No.");
         if RFQ_C.FindFirst() then;

         RFQ.Reset();
         RFQ.SetRange("Document No.", RFQ_C."Document No.");
         RFQ.SetRange("No.", RFQ_C."Item No.");
         //RFQ.SetRange("Vendor No.", RFQ_C."Vendor No.");
         RFQ.SetRange("Line No.", RFQ_C."Line No.");
         if RFQ.FindFirst() then begin
             RFQ."Unit Cost" := RFQ_C.Price;
             RFQ."Vendor No." := RFQ_C."Vendor No.";
             RFQ."Line Amount" := RFQ.Quantity * RFQ."Unit Cost";
             RFQ.Modify();
         end;
     end;
 */
    trigger OnClosePage()
    var
    Begin

    End;

    var
    //myInt: Record 37;
}