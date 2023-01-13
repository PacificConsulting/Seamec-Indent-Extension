tableextension 50122 Purch_Pay_setup_ext extends "Purchases & Payables Setup"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466,//PCPL AntiCost

    fields
    {
        field(50101; "Indent No."; Code[10])
        {
            Description = 'INDENT';
            TableRelation = "No. Series";
        }

        field(50102; "Indent No.1"; Code[10])
        {
            Description = 'INDENT';
            TableRelation = "No. Series";
        }

    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

