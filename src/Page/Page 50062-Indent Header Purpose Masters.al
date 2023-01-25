page 50062 "Indent Header Purpose Masters"
{
    PageType = List;
    Editable = false;
    CardPageId = "Indent Hdr Purpose Master Card";
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Indent Header Purpose Master";

    layout
    {
        area(Content)
        {
            repeater(Control)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}