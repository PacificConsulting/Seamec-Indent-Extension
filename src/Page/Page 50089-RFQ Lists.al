page 50089 "RFQ List"
{
    //--PCPL/0070/13Feb2023
    PageType = List;
    Caption = 'RFQ Lists';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "RFQ Header";
    Editable = false;
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

            }
        }
    }

    actions
    {
        area(Processing)
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
                begin
                    /*
                    EncryptedText := CryptographyManagement.EncryptText('36');  //Encrypt('36');

                    //Evaluate(IntValue)
                    URL := 'https://businesscentral.dynamics.com/a9f3ea0c-8063-42f9-891d-8d81b667b2d0/SeamecSandbox?Table=%1';
                    Message(URL + EncryptedText);

                    DecrValue := StrSubstNo(URL, EncryptedText);
                    Message(DecrValue);
                    // DecrValue := CryptographyManagement.Decrypt(EncryptedText);
                    // URL := 'https://businesscentral.dynamics.com/a9f3ea0c-8063-42f9-891d-8d81b667b2d0/SeamecSandbox?Table=DecrValue';
                    // Message(URL + DecrValue);
                    */
                end;
            }
        }
    }

    var
        myInt: Integer;
}