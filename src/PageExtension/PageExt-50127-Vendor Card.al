pageextension 50127 VendorCardExte extends "Vendor Card"
{
    layout
    {
        addafter("Address 2")
        {
            field(Password; Rec.Password)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        addafter("&Purchases")
        {
            action(GOTOLink)
            {
                ApplicationArea = All;
                Caption = 'GOTOLink';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    CryptographyManagement: Codeunit "Cryptography Management";
                    EncryptedText: Text;
                    URL: Text;
                    IntValue: Integer;
                    DecrValue: Text;
                    Vend: Record Vendor;
                    CU: Codeunit 50021;
                    Returndata: Text;
                begin
                    /*
                    EncryptedText := CryptographyManagement.EncryptText('RD9i1dXa13CxA&start_radio=1');  //Encrypt('36');
                    URL := 'https://www.youtube.com/watch?v=9i1dXa13CxA&list=%1';
                
                    DecrValue := StrSubstNo(URL, EncryptedText);
                    Message(URL + DecrValue);
                    Hyperlink(DecrValue);
                    */
                    //  Returndata := cu.DecryptText(Rec.Name);
                    // Message(Returndata);


                end;
            }
        }
    }


    var
        myInt: Integer;
}
