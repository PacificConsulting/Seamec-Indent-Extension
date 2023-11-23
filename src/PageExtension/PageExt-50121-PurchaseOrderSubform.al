pageextension 50121 Purch_order_subform_indent extends "Purchase Order Subform"
{
    layout
    {
        addafter("Unit Cost (LCY)")
        {
            field("RFQ Remarks"; Rec."RFQ Remarks")
            {
                ApplicationArea = All;
            }
            field("Service Indent No."; Rec."Service Indent No.")
            {
                ApplicationArea = All;
            }
            field("Indent No."; Rec."Indent No.") //pcpl-06411oct2023
            {
                ApplicationArea = all;
            }
            field("Indent Line No."; Rec."Indent Line No.") //pcpl-06411oct2023
            {
                ApplicationArea = all;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    //PCPL-0070 27June23 <<
    trigger OnDeleteRecord(): Boolean
    var
        IndentHdr: Record "Indent Header";
    Begin
        IndentHdr.Reset();
        IndentHdr.SetRange("No.", Rec."Service Indent No.");
        IF IndentHdr.FindFirst() then begin
            if IndentHdr."Po Created" then begin
                IndentHdr."Po Created" := false;
                IndentHdr.Modify();
            end;
        end;
    End;
    //PCPL-0070 27June23 <<

    procedure GetIndentLines()
    begin
        RunIndent;
    end;

    procedure RunIndent()
    Begin
        CLEAR(GetIndent);
        PurchHeader1.RESET;

        PurchHeader1.SETRANGE(PurchHeader1."Document Type", PurchHeader1."Document Type"::Order);
        PurchHeader1.SETRANGE(PurchHeader1."No.", Rec."Document No.");
        //IF "Location Code"<>'' THEN
        //PurchHeader1.SETRANGE(PurchHeader1."Location Code","Location Code");
        IF PurchHeader1.FINDFIRST THEN BEGIN

            //ROBOSOFT001--START  //ROBOSOFT001--END
            PurcIndnettLine.RESET;
            PurcIndnettLine.SETRANGE(PurcIndnettLine."Location Code", PurchHeader1."Location Code");
            //PurcIndnettLine.SETRANGE(PurcIndnettLine.Approved, TRUE);
            //PurcIndnettLine.SETRANGE(PurcIndnettLine.Status, TRUE);
            PurcIndnettLine.SETRANGE(PurcIndnettLine."Outstanding True", FALSE);
            PurcIndnettLine.SetRange("Indent Type", PurcIndnettLine."Indent Type"::Service); //PCPL-0070 26June23 
            //ROBOSOFT001--END
            GetIndent.SETTABLEVIEW(PurcIndnettLine);

            GetIndent.LOOKUPMODE := TRUE;
        END;
        GetIndent.EDITABLE(FALSE);
        GetIndent.SetPurchHeaderIndent(PurchHeader1);
        IF GetIndent.RUNMODAL <> ACTION::Cancel THEN;

    End;

    var
        PurchHeader1: Record 38;
        GetIndent: page 50066;
        PurcIndnettLine: Record 50023;
}