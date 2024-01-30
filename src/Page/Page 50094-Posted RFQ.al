page 50094 "Archive RFQ"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RFQ Header";
    Caption = 'Archive RFQ';
    SourceTableView = where("Created PO" = const(true));
    Editable = False;
    CardPageId = 50091;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = All;
                }
                field("PO Cancelled"; Rec."PO Cancelled")
                {
                    ApplicationArea = all;

                }

            }
        }
    }
    var
        myInt: Integer;
}