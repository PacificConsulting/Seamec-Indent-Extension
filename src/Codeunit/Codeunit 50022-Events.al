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

    //PCPL-25/280723
    local procedure OnAfterInsertReceiptHeader(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    begin
        PurchRcptHeader."Posting Date" := Today;
        PurchRcptHeader."Document Date" := Today;
    end;
    //PCPL-25/280723


    //PCPL-25/220823
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        EquipmentMaster: Record "Equipment Master";
        IndentH: Record "Indent Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Indent Header":
                begin
                    RecRef.Open(DATABASE::"Indent Header");
                    if IndentH.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(IndentH);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Indent Header":
                begin
                    FieldRef := RecRef.Field(50102);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Indent Header":
                begin
                    FieldRef := RecRef.Field(50102);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
    //PCPL-25/220823
    var
        myInt: Integer;
}