pageextension 50127 VendorCardExte extends "Vendor Card"
{
    layout
    {
        addafter("Address 2")
        {
            // field(Password; Rec.Password)
            // {
            //     ApplicationArea = All;
            // }

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

                    // EncryptedText := CryptographyManagement.EncryptText('RD9i1dXa13CxA&start_radio=1');  //Encrypt('36');
                    // URL := 'https://www.youtube.com/watch?v=9i1dXa13CxA&list=%1';

                    // DecrValue := StrSubstNo(URL, EncryptedText);
                    // Message(URL + DecrValue);
                    // Hyperlink(DecrValue);
                    DecrValue := 'cXjl2Qi5cf8/pdLmrlzn33gJwq822STaCGAt/FOoUbPP5XNBgzKqII9J/UJ1MRRdAH3P7AsbNEjDWGoQCYppMKo5piPRu2cNzEvn3iB4AVamC7y4QHFTZk3rLCOhQMOKSiIP5Ns3X0gT6GRJ/BnS+cisil1uonqnR9h5fkyCr1fwgsqx3ZBKUYO+7t9vlU5SN24EuPnGh98wRhqnJMjpRhnz74e6/RsgAGMLueHZyilsTsJ4qi3IjmhrRO0OFuHDPYDfymZLicFIenpLr1QDvQMu2Gtivg5sTlhYN8X1gA2ojEd9NTL18bctcGmZwTeibiMJqWQCNpyssRQckEq9wQ==';
                    Returndata := CU.DecryptText(DecrValue);

                    Message(Returndata);


                end;
            }
        }
    }


    var
        myInt: Integer;
}
