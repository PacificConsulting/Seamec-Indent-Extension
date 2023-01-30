tableextension 50127 User_setup_ext extends "User Setup"
{
    // version NAVW19.00.00.45778,QC2.0,PCPL-Indent 7.00.01,PCPL/QC/V3/001,PCPL-25/proofExp,PCPL-Permission

    fields
    {

        field(50101; "Location Code"; Code[100])
        {
        }
        field(50102; "Indent Approver"; Boolean)
        {
        }
        field(50103; "Indent Releaser"; Boolean)
        {
        }
        field(50104; "First Indent Approver"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            Description = 'PCPL-0070';
        }
        field(50105; "Second Indent Approver"; Boolean)
        {
            Description = 'PCPL-0070';
        }

    }

}

