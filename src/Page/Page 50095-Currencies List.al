page 50095 "Currencies List"
{
    ApplicationArea = All;
    Caption = 'Currencies List';
    PageType = List;
    SourceTable = Currency;
    UsageCategory = Lists;
    SourceTableView = where(Code = filter('*V*'));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a currency code that you can select. The code must comply with ISO 4217.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a text to describe the currency code.';
                }
            }
        }
    }
}
