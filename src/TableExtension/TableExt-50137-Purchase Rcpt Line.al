tableextension 50137 PurchRcptLineExt extends "Purch. Rcpt. Line"
{
    fields
    {
        field(50105; "RFQ Remarks"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}