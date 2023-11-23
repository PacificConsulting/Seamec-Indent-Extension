pageextension 50133 PurchaseOrderListExt extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("RFQ Indent No."; Rec."RFQ Indent No.")
            {
                ApplicationArea = All;
            }
        }

        addlast(Control1)
        {
            field("Show Vessel GRN"; Rec."Show Vessel GRN")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    //PCPL-25/270723
    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(2);
        Rec.SetRange("Show Vessel GRN", false);
        Rec.FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    var
        PL: Record "Purchase Line";
        TotQty: Decimal;
        TotRecived: Decimal;
    begin
        if (Rec."Show Vessel GRN" = false) and (Rec.Status = Rec.Status::Released) then begin
            Clear(TotQty);
            Clear(TotRecived);
            PL.Reset();
            PL.SetRange("Document No.", Rec."No.");
            if PL.FindSet() then
                repeat
                    TotQty += PL.Quantity;
                    TotRecived += PL."Quantity Received";
                until PL.Next() = 0;
            if TotQty = TotRecived then begin
                Rec."Show Vessel GRN" := true;
                Rec.Modify();
            end;
        end;
    end;
    //PCPL-25/270723
    var
        myInt: Integer;
}