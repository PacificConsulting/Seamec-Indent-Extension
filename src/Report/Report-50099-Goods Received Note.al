report 50099 "Goods Received Note"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './Src/ReportLayout/Goods Received Note -1.rdl';

    dataset
    {
        dataitem("Purch. Rcpt. Header"; "Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Posting Date";
            column(Receipt_No_; "No.")
            {
            }
            column(Posting_Date; "Posting Date")
            {

            }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
            {

            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {

            }
            column(Location_Code; "Location Code")
            {

            }
            column(Shortcut_Dimension_2_Code; "Shortcut Dimension 2 Code")
            {

            }
            column(Order_No_; "Order No.")
            {

            }
            column(comPicture; cominfo.Picture)
            {

            }
            column(locationName; locationName)
            {

            }


            dataitem("Purch. Rcpt. Line"; "Purch. Rcpt. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Purch. Rcpt. Header";
                column(No_; "No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Type; Type)
                {

                }
                column(Bin_Code; "Bin Code")
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(SrNo; SrNo)
                {

                }

                dataitem("Value Entry"; "Value Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                    "Document Line No." = FIELD("Line No.");
                    dataitem("Item Ledger Entry"; "Item Ledger Entry")
                    {

                        DataItemLink = "Entry No." = FIELD("Item Ledger Entry No.");
                        column(Lot_No_; "Item Ledger Entry"."Lot No.")
                        {

                        }
                    }
                }


                trigger OnAfterGetRecord()
                var
                    myInt: Integer;
                begin

                end;

            }
            trigger OnAfterGetRecord()//PRH
            begin
                if Reclocation.Get("Location Code") then
                    locationName := Reclocation.Name;
            end;

            trigger OnPreDataItem()
            begin
                cominfo.get();
                cominfo.CalcFields(Picture);
                SrNo += 1;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }

    var
        myInt: Integer;
        cominfo: Record "Company Information";
        Reclocation: Record Location;
        locationName: text[60];
        SrNo: Integer;
}