page 50101 "Vessel PO List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Vessel GRN';
    CardPageID = "Vessel PO";
    //DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    //QueryCategory = 'Vessel PO List';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    //SourceTableView = WHERE("Document Type" = CONST(Order));
    SourceTableView = WHERE("Document Type" = CONST(Order), Status = filter(Released), "Show Vessel GRN" = const(false));  //PCPL-25/180723 above code comment
    UsageCategory = Lists;
    DeleteAllowed = false;      //PCPL-25/100723

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a unique number that identifies the purchase order. The number can be generated automatically from a number series, or you can number each of them manually.';
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor who will deliver the goods or services. Each vendor has a unique number to help you track related documents. The number can come from a number series or be added manually.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the vendor that you’re buying from. By default, the same vendor is suggested as the pay-to vendor. If needed, you can specify a different pay-to vendor on the document.';
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the post code of the vendor who delivered the items.';
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.';
                    Visible = false;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the contact person at the vendor who delivered the items.';
                    Visible = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
                    Visible = false;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the vendor who you received the invoice from.';
                    Visible = false;
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the post code of the vendor that you received the invoice from.';
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the country/region code of the address.';
                    Visible = false;
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the person to contact about an invoice from this vendor.';
                    Visible = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("RFQ Indent No."; Rec."RFQ Indent No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        PL: Record "Purchase Line";
        TotQty: Decimal;
        TotRecived: Decimal;
    begin
        if (Rec."Show Vessel GRN" = false) then begin
            Clear(TotQty);
            Clear(TotRecived);
            PL.Reset();
            PL.SetRange("Document No.", Rec."No.");
            if PL.FindSet() then
                repeat
                    TotQty += PL.Quantity;
                    TotRecived += PL."Quantity Received";
                until PL.Next() = 0;
            if (TotQty = TotRecived) and (TotQty <> 0) then begin
                Rec."Show Vessel GRN" := true;
                Rec.Modify();
            end;
        end;
    end;
}