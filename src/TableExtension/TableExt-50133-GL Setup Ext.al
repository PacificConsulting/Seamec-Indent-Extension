tableextension 50133 "GL Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50132; "RFQ URL"; Text[100])
        {
            Caption = 'RFQ URL';
            DataClassification = ToBeClassified;
        }
        field(50133; "Quotation Received Mail"; text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50134; "RFQ CC Mail"; text[80])
        {
            DataClassification = ToBeClassified;

        }
        field(50135; "RFQ CC_2 Mail"; text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'PCPL-064 30jan2024';
        }
    }
}
