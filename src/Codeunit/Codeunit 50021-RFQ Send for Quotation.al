codeunit 50021 "RFQ-Send for Quotation"
{
    //PCPL-0070 27Feb2023
    trigger OnRun()
    begin

    end;

    procedure SendForQuotation(DocNo: Code[20])
    var
        RFQLine: Record "RFQ Line";
        ItemVend: Record "Item Vendor";
        RFQCatalog: Record "RFQ Catalog";
        LineNo: Integer;
        Rec: Record "RFQ Header";
    Begin
        if Rec.GET(DocNo) then begin
            RFQLine.Reset();
            RFQLine.SetRange("Document No.", Rec."Document No.");
            if RFQLine.FindSet() then
                repeat
                    ItemVend.Reset();
                    ItemVend.SetRange("Item No.", RFQLine."No.");
                    if ItemVend.FindSet() then begin
                        repeat
                            RFQCatalog.Reset();
                            RFQCatalog.SetRange("Document No.", Rec."Document No.");
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
                Error('Lines Does not Exist in %1 order', Rec."Document No.");
            Message('Quotation Insert Successfully');
            RFQCatalog.Reset();
            RFQCatalog.SetRange("Document No.", Rec."Document No.");
            if RFQCatalog.FindSet() then
                repeat
                    SendMailForVendor(RFQCatalog);
                until RFQCatalog.Next() = 0;
        End Else
            Error('Document No Found with %1', DocNo);
    end;

    procedure SendMailForVendor(RFQ_Catalog: Record "RFQ Catalog")
    var
        RecVendor: Record Vendor;
        RecItem: Record Item;
        RFQHdr: Record "RFQ Header";
        RFQLine: Record "RFQ Line";
    Begin
        RecVendor.GET(RFQ_Catalog."Vendor No.");
        RecItem.Get(RFQ_Catalog."Item No.");
        CompanyInfo.GET;
        RFQHdr.GET(RFQ_Catalog."Document No.");
        RFQLine.GET(RFQ_Catalog."Document No.", RFQ_Catalog."Line No.");

        bodytext1 += ('Dear Sir/Madam');
        bodytext1 += ('<br><Br>');
        bodytext1 += ('We request you to submit your quote for our following requirement. For details click on Web Link.');
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
        VarRecipaints := 'deepak.rajauria@pacificconsulting.in';
        EmailMessage.Create(VarRecipaints, 'Request For Quote : ' + RecItem.Description, bodytext1, true);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        Message('E-mail sent successfully');
    End;

    var
        myInt: Integer;
        Email: Codeunit Email;
        EmailMessage: codeunit "Email Message";
        bodytext1: Text;
        CompanyInfo: Record "Company Information";
        VarRecipaints: Text[80];
}