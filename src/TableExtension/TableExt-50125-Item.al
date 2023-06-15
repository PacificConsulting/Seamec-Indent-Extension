tableextension 50125 Item_Indent_ext extends Item
{
    fields
    {

        field(50101; "Blocked Type"; Option)
        {
            OptionCaption = '" ,Indent,Purchase"';
            OptionMembers = " ",Indent,Purchase;
        }
        //PCPL-25/090323
        field(50102; "Item Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        //PCPL-25/090323
    }

    //PCPL-25/090323
    trigger OnAfterInsert()
    begin
        "Costing Method" := "Costing Method"::Average;
        "Gen. Prod. Posting Group" := 'SPARES-LOC';
        "Inventory Posting Group" := 'OTHER';
    end;
    //PCPL-25/090323


}