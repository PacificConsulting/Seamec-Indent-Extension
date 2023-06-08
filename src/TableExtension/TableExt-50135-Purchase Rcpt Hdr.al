tableextension 50135 PurchRcptHdrExt extends "Purch. Rcpt. Header"
{
    fields
    {
        field(50103; "RFQ Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-0070 03Mar2023';
            Editable = false;
        }
    }

    var
        myInt: Integer;
}