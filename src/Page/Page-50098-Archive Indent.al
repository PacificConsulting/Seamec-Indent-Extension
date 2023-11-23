page 50098 "Archive Indent"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Indent Header";
    SourceTableView = where("PO Created" = const(true));
    Editable = False;
    CardPageId = 50063;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = all;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field("Indent Description"; Rec."Indent Description")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = all;
                }

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = all;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = all;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = all;
                }
                field("No. Series"; Rec."No. Series")
                {
                    Editable = true;
                    ApplicationArea = all;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = all;
                }
                field("Total Qty"; Rec."Total Qty")
                {
                    ApplicationArea = all;
                }
                field(Category; Rec.Category)
                {
                    ApplicationArea = all;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = all;
                    //  OptionCaption = '" ,Project,Maintenance,Production,Quality Control,Research and Devolopment,Electrical,Instrument,Civil>"';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("Release User ID"; Rec."Release User ID")
                {
                    ApplicationArea = all;
                }
                field("Material category"; Rec."Material category")
                {
                    ApplicationArea = all;
                }
                // field("Closed By"; Rec."Closed By")
                // {
                //     ApplicationArea = all;
                // }
                // field("Closed Date"; Rec."Closed Date")
                // {
                //     ApplicationArea = all;
                // }
            }
        }
    }

}