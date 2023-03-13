tableextension 50132 VendorExte extends Vendor
{
    fields
    {
        field(50101; Password; Text[20])
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL/0070 24Feb2023';
        }

    }

    var
        myInt: Integer;
}