tableextension 50131 Job_Ext extends Job
{
    // version NAVW19.00.00.46621,NAVIN9.00.00.46621,PCPL-JOB0001

    fields
    {


        // field(50101; Purpose; Option)
        // {
        //     OptionCaption = '" ,Project,Maintenance,Production,Quality Control,Research and Devolopment,Electrical,Instrument,Civil,Upgradation"';
        //     OptionMembers = " ",Project,Maintenance,Production,"Quality Control","Research and Devolopment",Electrical,Instrument,Civil,Upgradation;
        // }
        field(50101; Purpose; Text[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Indent Header Purpose Master".Name;
        }
    }

    //Unsupported feature: PropertyChange. Please convert manually.

}

