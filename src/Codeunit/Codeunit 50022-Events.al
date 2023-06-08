codeunit 50022 EventsSubscribers
{
    trigger OnRun()
    begin

    end;
    //PCP-0070 01June23 <<
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnAfterCopyFromPurchRcptLine', '', false, false)]
    local procedure OnAfterCopyFromPurchRcptLine(var PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line"; var TempPurchLine: Record "Purchase Line");
    var
        PH: Record "Purchase Header";
    begin
        PurchaseLine."Order No." := PurchRcptLine."Order No.";
        PurchaseLine.Validate("Shortcut Dimension 1 Code", PurchRcptLine."Shortcut Dimension 1 Code");
        PurchaseLine.Validate("Shortcut Dimension 2 Code", PurchRcptLine."Shortcut Dimension 2 Code");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var Handled: Boolean);
    begin
        PurchLine.Description := 'Receipt No. ' + PurchRcptLine."Document No." + ': Date: ' + Format(PurchRcptLine."Posting Date");
    end;
    //PCP-0070 01June23 >>
    var
        myInt: Integer;
}