tableextension 50136 PurchInvLineExt1 extends "Purch. Inv. Line"
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