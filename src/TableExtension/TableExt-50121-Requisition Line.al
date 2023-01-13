tableextension 50121 Requisition_Line_Ext extends "Requisition Line"
{
    // version NAVW19.00.00.48316

    fields
    {
        field(50101; Indented; Boolean)
        {
        }
        field(50102; "Entry no"; Code[20])
        {
            Description = 'INDENT';
        }
        field(50103; "Indent Line No"; Integer)
        {
        }
        field(50104; Comment; Text[230])
        {
            Description = 'PCPL BRB';
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

