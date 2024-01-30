tableextension 50139 purchaseHeaderArchi_ext extends "Purchase Header Archive"
{
    fields
    {
        field(50000; "PO Cancelled"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064 26dec2023';
        }
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}