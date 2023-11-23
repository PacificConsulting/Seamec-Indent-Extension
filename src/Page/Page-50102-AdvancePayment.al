page 50102 "Advance Payment"
{
    PageType = CardPart;
    ApplicationArea = All;
    Caption = 'Advance Payment';


    layout
    {
        area(Content)
        {
            cuegroup("Advance Payment")
            {
                field("Vendor Advance"; Total_RemainingAmt)   //PCPL-25/280623 heading change "total_remamimng to vendor advance" vendor advance
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        VenLedEntry: Record 25;
                        T25: Record 25;
                        Date1: Date;
                    Begin
                        PurchPaybleSetup.Get();
                        VenLedEntry.Reset();
                        VenLedEntry.SetRange("Document Type", VenLedEntry."Document Type"::Payment);
                        VenLedEntry.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
                        IF VenLedEntry.FindLast() then;

                        Date1 := CalcDate(Format(PurchPaybleSetup."Gross Period Date"), VenLedEntry."Posting Date");

                        T25.Reset();
                        T25.SetRange("Document Type", T25."Document Type"::Payment);
                        T25.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
                        T25.SetFilter("Posting Date", '<%1', beforeDate);
                        If T25.FindSet() then begin
                            IF Page.RunModal(29, T25) = Action::None then;
                        end;
                    End;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        VLE: Record "Vendor Ledger Entry";

    begin
        if PurchPaybleSetup.GET() then;

        VLE.Reset();
        VLE.SetRange("Document Type", VLE."Document Type"::Payment);
        Rec_VLE.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
        IF VLE.FindLast() then;
        beforeDate := CalcDate(Format(PurchPaybleSetup."Gross Period Date"), VLE."Posting Date");

        Rec_VLE.Reset();
        Rec_VLE.SetRange("Document Type", Rec_VLE."Document Type"::Payment);
        Rec_VLE.SetFilter("Remaining Amt. (LCY)", '>%1', 0);
        Rec_VLE.SetFilter("Posting Date", '<%1', beforeDate);
        If Rec_VLE.FindSet() then
            repeat
                Rec_VLE.CalcFields("Remaining Amt. (LCY)");
                Total_RemainingAmt += Rec_VLE."Remaining Amt. (LCY)";
            until Rec_VLE.Next() = 0;
    end;

    var
        myInt: Record 9053;
        Rec_VLE: Record "Vendor Ledger Entry";
        Total_RemainingAmt: Decimal;
        beforeDate: Date;
        PurchPaybleSetup: Record "Purchases & Payables Setup";
}