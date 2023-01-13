tableextension 50130 Job_Planing_Line extends "Job Planning Line"
{
    fields
    {
        field(50101; "Qty. to Indent"; Decimal)
        {
            Description = 'PCPL-JOB0001';

            trigger OnValidate();
            begin
                IF ("Qty. to Indent" + "Qty. Indented") > Quantity THEN
                    ERROR('Can not exceed qty');
            end;
        }
        field(50102; "Qty. Indented"; Decimal)
        {
            Description = 'PCPL-JOB0001';
        }
    }

    var
        myInt: Integer;
}