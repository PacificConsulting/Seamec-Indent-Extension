tableextension 50134 PurchInvHdrExt1 extends "Purch. Inv. Header"
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