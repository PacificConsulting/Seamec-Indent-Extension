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
    SourceTableView = where("Created PO" = const(false));

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
                    Item: Record 27;
                begin

                    EncryptedText := CryptographyManagement.EncryptText('RD9i1dXa13CxA&start_radio=1');  //Encrypt('36');

                    //Evaluate(IntValue)
                    URL := 'https://www.youtube.com/watch?v=9i1dXa13CxA&list=%1';
                    //Message(URL + EncryptedText);

                    DecrValue := StrSubstNo(URL, EncryptedText);
                    //Message(DecrValue);
                    // DecrValue := CryptographyManagement.Decrypt(EncryptedText);
                    // URL := 'https://businesscentral.dynamics.com/a9f3ea0c-8063-42f9-891d-8d81b667b2d0/SeamecSandbox?Table=DecrValue';
                    Message(URL + DecrValue);

                end;
            }
        }
    }

    var
        myInt: Integer;
}