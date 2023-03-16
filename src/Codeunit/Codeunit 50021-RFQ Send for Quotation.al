codeunit 50021 "RFQ-Send for Quotation"
{
    //PCPL-0070 27Feb2023
    trigger OnRun()
    begin

    end;

    procedure SendForQuotation(docno: Text): Text
    var
        RFQLine: Record "RFQ Line";
        ItemVend: Record "Item Vendor";
        RFQCatalog: Record "RFQ Catalog";
        LineNo: Integer;
        Rec: Record "RFQ Header";
    Begin

        if Rec.GET(DocNo) then begin
            RFQLine.Reset();
            RFQLine.SetRange("Document No.", Rec."No.");
            if RFQLine.FindSet() then
                repeat
                    ItemVend.Reset();
                    ItemVend.SetRange("Item No.", RFQLine."No.");
                    if ItemVend.FindSet() then begin
                        repeat
                            RFQCatalog.Reset();
                            RFQCatalog.SetRange("Document No.", Rec."No.");
                            RFQCatalog.SetRange("Vendor No.", ItemVend."Vendor No.");
                            if not RFQCatalog.FindFirst() then begin
                                RFQCatalog.Init();
                                RFQCatalog.Validate("Document No.", RFQLine."Document No.");
                                RFQCatalog.Validate("Line No.", RFQLine."Line No.");
                                RFQCatalog.Validate("Vendor No.", ItemVend."Vendor No.");
                                RFQCatalog.Validate("Item No.", ItemVend."Vendor Item No.");
                                RFQCatalog.Validate(Quantity, RFQLine.Quantity);
                                RFQCatalog.Insert();
                            End;
                        until ItemVend.Next() = 0;
                    End Else
                        Error('Vendor catalog does not exist');
                until RFQLine.Next() = 0
            else
                Error('Lines Does not Exist in %1 order', Rec."No.");
            Message('Quotation Insert Successfully');
            RFQCatalog.Reset();
            RFQCatalog.SetRange("Document No.", Rec."No.");
            if RFQCatalog.FindSet() then
                repeat
                //SendMailForVendor(RFQCatalog);
                until RFQCatalog.Next() = 0;
        End Else begin
            Error('Document No Found with %1', DocNo);
            exit('Failed ' + docno);
        end;

        exit('Success ' + docno);
    end;

    procedure SendMailForVendor(RFQ_Catalog: Record "RFQ Catalog")
    var
        RecVendor: Record Vendor;
        RecItem: Record Item;
        RFQHdr: Record "RFQ Header";
        RFQLine: Record "RFQ Line";
        CC: List of [Text];
        BCC: List of [Text];
        Url: Text;
        DecryptedValue: Text;
        EncryptedDoc: Text;
        EncryptedVend: Text;
        CryptographyManagement: Codeunit "Cryptography Management";
        GLSetup: Record 98;
    Begin
        GLSetup.Get();
        RecVendor.GET(RFQ_Catalog."Vendor No.");
        RecItem.Get(RFQ_Catalog."Item No.");
        CompanyInfo.GET;
        RFQHdr.GET(RFQ_Catalog."Document No.");
        RFQLine.GET(RFQ_Catalog."Document No.", RFQ_Catalog."Line No.");

        URL := GLSetup."RFQ URL" + 'rfqdetail.aspx?param1=%1&param2=%2';
        //URL := 'http://localhost:54939/rfqdetail.aspx?param1=%1&param2=%2';
        //http://10.20.1.99:8082/rfquat/rfqdetail.aspx?param1=%1&param2=%2'

        EncryptedDoc := CryptographyManagement.EncryptText(RFQ_Catalog."Document No.");
        EncryptedVend := CryptographyManagement.EncryptText(RecVendor."No.");
        DecryptedValue := StrSubstNo(URL, EncryptedDoc, EncryptedVend);
        //RFQ_Catalog."Document No."
        //RFQ_Catalog."Vendor No."

        bodytext1 += ('Dear Sir/Madam');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('We request you to submit your quote for our following requirement. For details click on Web Link.');

        bodytext1 += ('<br><Br>');
        bodytext1 += '<a href="Web Link" class="btn btn-primary">' + DecryptedValue + '</a>';
        bodytext1 += ('<br><Br>');

        bodytext1 += ('<td style="text-align:center" colspan=8><b> ' + CompanyInfo.Name + '</b></td>');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('<tr style="background-color:#507CD1; color:#fff">');
        bodytext1 += ('<th> Date </th>');
        BodyText1 += '<th> Document No. </th>';
        BodyText1 += '<th> Item No. </th>';
        BodyText1 += '<th> Description </th>';
        BodyText1 += '<th> Vendor No. </th>';
        BodyText1 += '<th> Quantity </th>';
        BodyText1 += '<th> UOM </th>';
        bodytext1 += ('<th> Web Link </th>');
        BodyText1 += '</tr>';
        bodytext1 += ('<tr style="background-color:#EFF3FB; color:black">');
        BodyText1 += ('<td>' + FORMAT(RFQHdr.Date) + '</td>');
        BodyText1 += ('<td>' + FORMAT(RFQ_Catalog."Document No.") + '</td>');
        BodyText1 += ('<td>' + FORMAT(RFQ_Catalog."Item No.") + '</td>');
        BodyText1 += ('<td>' + RecItem.Description + '</td>');
        BodyText1 += ('<td>' + Format(RFQ_Catalog."Vendor No.") + '</td>');
        BodyText1 += ('<td>' + FORMAT(RFQ_Catalog.Quantity) + '</td>');
        BodyText1 += ('<td>' + FORMAT(RFQLine."Unit of Measure Code") + '</td>');
        BodyText1 += ('<td>' + '' + '</td>');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('<th> Vendor Name:' + RecVendor.Name + '</th>');
        bodytext1 += ('<th style="text-align:left"> Vendor User ID: ' + RecVendor."No." + '</th>');
        bodytext1 += ('<th style="text-align:left"> Vendor Password:' + RecVendor.Password + '</th>');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('<br><Br>');
        BodyText1 += ('<td style="text-align:left" colspan=8><b>' + 'Thanks & Regards' + '</b></td>');
        BodyText1 += '<br><br>';
        BodyText1 += 'Warm Regards,';
        BodyText1 += ('<td style="text-align:left" colspan=8><b> ' + CompanyInfo.Name + '</b></td>');
        BodyText1 += '<br><br>';
        VarRecipaints := 'kamalkant@pacificconsulting.in';
        EmailMessage.Create(VarRecipaints, 'Request For Quote : ' + RecItem.Description, bodytext1, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        Message('E-mail sent successfully');

    End;

    procedure UpdateRFQLine(documentNo: Text; lineNo: Integer; remarks: Text[100]; price: Decimal): text
    var
        RFQLine: Record "RFQ Line";
        RFQCatelog: record "RFQ Catalog";
    begin
        RFQLine.Reset();
        RFQLine.SetRange("Document No.", documentNo);
        RFQLine.SetRange("Line No.", lineNo);
        IF RFQLine.FindFirst() then begin
            RFQLine.Remark := remarks;
            RFQLine.Price := price;
            RFQLine.Modify();
            exit('Success');
        end;
        /*
        RFQCatelog.Reset();
        RFQCatelog.SetRange("Document No.", documentNo);
        RFQCatelog.SetRange("Line No.", lineNo);
        IF RFQCatelog.FindFirst() then begin
            RFQCatelog.Remarks := remarks;
            RFQCatelog.Price := price;
            RFQCatelog.Modify();
            exit('Success');
        end;
        
        RFQCatelog.Reset();
        RFQCatelog.SetRange("Document No.", documentNo);
        RFQCatelog.SetRange("Item No.",itemno); //itemno will come from portal kamal send.
        RFQCatelog.SetCurrentKey(Price);
        IF RFQCatelog.FindFirst() then begin
            RFQLine.Reset();
            RFQLine.SetRange("Document No.", documentNo);
            RFQLine.SetRange("Line No.", lineNo);
            IF RFQLine.FindFirst() then begin
                RFQLine."Unit Cost" := RFQCatelog.Price;
                RFQLine.Remark := RFQCatelog.Remarks;
                RFQLine."Vendor No." := RFQCatelog."Vendor No.";
                RFQLine.Modify();

                RFQCatelog.Remarks := remarks;
                RFQCatelog.Price := price;
                RFQCatelog.Modify();
                exit('Success');
            END;
        end;
        */
    end;

    procedure DecryptText(input: Text): Text
    var
        CryptographyManagement: Codeunit "Cryptography Management";
        DecryptData: Text;
        EncrptDate: Text;
    begin
        //EncrptDate := CryptographyManagement.EncryptText(input);
        //Message(EncrptDate);
        //DecryptData := CryptographyManagement.Decrypt(input);
        DecryptData := CryptographyManagement.Decrypt(input);
        exit(DecryptData);
    end;



    var
        myInt: Integer;
        Email: Codeunit Email;
        EmailMessage: codeunit "Email Message";
        bodytext1: Text;
        CompanyInfo: Record "Company Information";
        VarRecipaints: Text[80];
}