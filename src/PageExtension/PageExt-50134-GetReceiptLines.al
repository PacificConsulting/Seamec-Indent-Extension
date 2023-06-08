pageextension 50134 GetReceiptLines extends "Get Receipt Lines"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    //PCPL-0070 02June23 <<
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        PL: Record "Purchase Line";
        PH: Record "Purchase Header";
    Begin
        IF Rec."Order No." <> '' then begin
            PL.Reset;
            PL.SetRange("Order No.", Rec."Order No.");
            IF PL.FindFirst() then begin
                IF PH.GET(PL."Document Type", PL."Document No.") then begin
                    PH.Validate("Shortcut Dimension 1 Code", PL."Shortcut Dimension 1 Code");
                    PH.Validate("Shortcut Dimension 2 Code", PL."Shortcut Dimension 2 Code");
                    Ph.Modify();
                end;
            end;
        end;
    End;
    //PCPL-0070 02June23 >>
    var
        myInt: Integer;
}