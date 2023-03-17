page 50091 "RFQ Card"
{
    //--PCPL/0070/13Feb2023
    PageType = Card;
    // ApplicationArea = All;
    //UsageCategory = Administration;
    SourceTable = "RFQ Header";
    Editable = true;
    Permissions = tabledata "RFQ Header" = RIMD;



    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field("USER ID"; Rec."USER ID")
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(RFQLines; 50090)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Send for Quoatation")
            {
                Caption = 'Send for Quotation';
                ApplicationArea = All;
                Image = Insert;
                Description = 'PCPL-0070 24Feb2023';
                trigger OnAction()
                var
                    RFQLine: Record "RFQ Line";
                    ItemVend: Record "Item Vendor";
                    RFQCatalog: Record "RFQ Catalog";
                    LineNo: Integer;
                    VendorNo: Code[20];
                Begin
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
                                Message('Quotation Insert Successfully');
                            End Else
                                Error('Vendor catalog does not exist');
                        until RFQLine.Next() = 0
                    else
                        Error('Lines Does not Exist in %1 order', Rec."No.");

                    RFQCatalog.Reset();
                    RFQCatalog.SetRange("Document No.", Rec."No.");
                    if RFQCatalog.FindSet() then
                        repeat
                            SendMailForVendor(RFQCatalog);
                        until RFQCatalog.Next() = 0;
                    Message('E-mail sent successfully');
                End;
            }
            action(CreatePO_)
            {
                Caption = 'Create PO';
                ApplicationArea = All;
                Image = Create;
                Description = 'PCPL-0070 28Feb2023';
                trigger OnAction()
                begin
                    CreatePO();
                end;
            }
        }
    }
    procedure SendMailForVendor(RFQ_Catalog: Record "RFQ Catalog")
    var
        RecVendor: Record Vendor;
        RecItem: Record Item;
        RFQHdr: Record "RFQ Header";
        RFQLine: Record "RFQ Line";
        DecryptedValue: Text[2048];
        DecryptedValue1: Text[2048];
        EncryptedDoc: Text;
        EncryptedVend: Text;
        CryptographyManagement: Codeunit "Cryptography Management";
        Url: Text;
        TypeHelper: Codeunit "Type Helper";
        GLSetup: Record 98;
    Begin
        Clear(bodytext1);
        GLSetup.Get();
        if RecVendor.GET(RFQ_Catalog."Vendor No.") then begin
            RecItem.Get(RFQ_Catalog."Item No.");
            CompanyInfo.GET;
            RFQHdr.GET(RFQ_Catalog."Document No.");
            RFQLine.GET(RFQ_Catalog."Document No.", RFQ_Catalog."Line No.");

            URL := GLSetup."RFQ URL" + 'rfqdetail.aspx?param1=%1&param2=%2';
            //URL := 'http://localhost:54939/rfqdetail.aspx?param1=%1&param2=%2';
            //'http://localhost:54939/rfqdetail.aspx?param1=value1&param2=value2'

            EncryptedDoc := CryptographyManagement.EncryptText(RFQ_Catalog."Document No.");
            EncryptedVend := CryptographyManagement.EncryptText(RecVendor."No.");

            EncryptedDoc := CryptographyManagement.EncryptText(RFQ_Catalog."Document No.").Replace('+', 'plustext');
            EncryptedVend := CryptographyManagement.EncryptText(RecVendor."No.").Replace('+', 'plustext');

            DecryptedValue1 := StrSubstNo(URL, CryptographyManagement.EncryptText(RFQ_Catalog."Document No.").Replace('+', 'plustext'), CryptographyManagement.EncryptText(RecVendor."No.").Replace('+', 'plustext'));
            DecryptedValue := DecryptedValue1.Replace('&', '*');
            // Message(DecryptedValue);
            //DecryptedValue := Url.Replace('param1=', 'param1=' + EncryptedDoc);
            //DecryptedValue := Url.Replace('param2=', 'param2=' + EncryptedVend);

            bodytext1 += ('Dear Sir/Madam');
            bodytext1 += ('<br><Br>');
            bodytext1 += ('We request you to submit your quote for our following requirement. For details click on Web Link.');
            bodytext1 += ('<br><Br>');

            //            bodytext1 += '<a href=' + DecryptedValue + '/">Click to Web Link!</a>';

            bodytext1 += ('<td style="text-align:center" colspan=8><b> ' + CompanyInfo.Name + '</b></td>');
            bodytext1 += ('<br><Br>');
            BodyText1 += '</tr>';
            BodyText1 += '</table>';
            BodyText1 += '<table border ="1">';
            bodytext1 += ('<th> Date </th>');
            BodyText1 += '<th> Document No. </th>';
            BodyText1 += '<th> Item No. </th>';
            BodyText1 += '<th> Description </th>';
            BodyText1 += '<th> Vendor No. </th>';
            BodyText1 += '<th> Quantity </th>';
            BodyText1 += '<th> UOM </th>';
            bodytext1 += ('<th> Web Link </th>');
            BodyText1 += '</tr>';
            /// bodytext1 += ('<tr style="background-color:#EFF3FB; color:black">');
            BodyText1 += '<tr>';
            BodyText1 += ('<td>' + FORMAT(RFQHdr.Date) + '</td>');
            BodyText1 += ('<td>' + FORMAT(RFQ_Catalog."Document No.") + '</td>');
            BodyText1 += ('<td>' + FORMAT(RFQ_Catalog."Item No.") + '</td>');
            BodyText1 += ('<td>' + RecItem.Description + '</td>');
            BodyText1 += ('<td>' + Format(RFQ_Catalog."Vendor No.") + '</td>');
            BodyText1 += ('<td>' + FORMAT(RFQ_Catalog.Quantity) + '</td>');
            BodyText1 += ('<td>' + FORMAT(RFQLine."Unit of Measure Code") + '</td>');
            BodyText1 += ('<td>' + '<a href=' + DecryptedValue + '/">Click to web Link!</a>' + '</td>');
            BodyText1 += '</tr>';
            BodyText1 += '</table>';
            bodytext1 += ('<br><Br>');
            bodytext1 += ('<th> Vendor Name : ' + RecVendor.Name + '</th>');
            bodytext1 += ('<br><Br>');
            // bodytext1 += ('<th style="text-align:left"> Vendor User ID : ' + RecVendor."No." + '</th>');
            // bodytext1 += ('<br><Br>');
            // bodytext1 += ('<th style="text-align:left"> Vendor Password : ' + RecVendor.Password + '</th>');
            // bodytext1 += ('<br><Br>');
            bodytext1 += ('<br><Br>');
            BodyText1 += ('<td style="text-align:left" colspan=8><b>' + 'Thanks & Regards' + '</b></td>');
            BodyText1 += '<br><br>';
            BodyText1 += ('<td style="text-align:left" colspan=8><b> ' + CompanyInfo.Name + '</b></td>');
            BodyText1 += '<br><br>';
            //  VarRecipaints.Add('ssarkar@seamec.in');
            VarRecipaints.Add('anshul.jain@pacificconsulting.in');
            //VarRecipaints.Add('nirmal.wagh@pacificconsulting.in');
            //VarRecipaints.Add(RecVendor."E-Mail");
            EmailMessage.Create(VarRecipaints, 'Request For Quote : ' + RecItem.Description, bodytext1, true);
            Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
            // Message('E-mail sent successfully');
        End;
        //Clear(bodytext1);
    End;

    procedure CreatePO()
    var
        PH: Record "Purchase Header";
        PL: Record "Purchase Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchSetup: Record "Purchases & Payables Setup";
        RFQLine: Record "RFQ Line";
        PH_No: Code[20];
        LineNo: Integer;
        LastVendorNo: code[20];
        PurchHdr: Record "Purchase Header";
    Begin
        PurchSetup.GET;

        RFQLine.reset;
        RFQLine.SetRange("Document No.", Rec."No.");
        RFQLine.SetFilter("Vendor No.", '<>%1', '');
        if RFQLine.FindSet() then
            LineNo := 10000;
        repeat
            PurchHdr.Reset();
            PurchHdr.SetRange("RFQ Indent No.", Rec."No.");
            PurchHdr.SetRange("Create PO by Indent", false);
            //PurchHdr.SetRange("Buy-from Vendor No.", RFQLine."Vendor No."); //It will be confirm by Anshul Sir.
            if not PurchHdr.FindFirst() then begin
                if RFQLine."Vendor No." <> '' then begin
                    if LastVendorNo <> RFQLine."Vendor No." then begin
                        PH.Init();
                        PH_No := NoSeriesMgt.GetNextNo(PurchSetup."Order Nos.", Today, true);
                        PH.Validate("No.", PH_No);
                        PH.Validate("Buy-from Vendor No.", RFQLine."Vendor No.");
                        PH.Validate("Document Type", PH."Document Type"::Order);
                        PH.Validate("Posting Date", Today);
                        PH."Create PO by Indent" := true;
                        PH."RFQ Indent No." := Rec."No.";
                        PH.Insert(true);
                        // Message('Purchase Order %1 has been created', PH."No.");
                        PL.init;
                        PL."Document No." := PH."No.";
                        PL."Document Type" := PH."Document Type";
                        PL."Line No." := LineNo;
                        PL.Type := PL.Type::Item;
                        PL."No." := RFQLine."No.";
                        if Item_Rec.GET(PL."No.") then;
                        PL.Description := Item_Rec.Description;
                        PL."Description 2" := Item_Rec."Description 2";
                        PL."Location Code" := RFQLine."Location Code";
                        PL.Quantity := RFQLine.Quantity;
                        PL."Unit of Measure Code" := RFQLine."Unit of Measure Code";
                        PL."Line Amount" := RFQLine."Line Amount";
                        PL."Direct Unit Cost" := RFQLine."Unit Cost";
                        PL.Insert();
                    End;
                    LastVendorNo := PH."Buy-from Vendor No.";
                    LineNo := LineNo + 10000;
                end ELse begin
                    PL.init;
                    PL.Validate("Document No.", PH."No.");
                    PL.Validate("Document Type", PH."Document Type");
                    PL."Line No." := LineNo;
                    PL.Type := PL.Type::Item;
                    PL."No." := RFQLine."No.";
                    if Item_Rec.GET(PL."No.") then;
                    PL.Description := Item_Rec.Description;
                    PL."Description 2" := Item_Rec."Description 2";
                    PL."Location Code" := RFQLine."Location Code";
                    PL.Quantity := RFQLine.Quantity;
                    PL."Unit of Measure Code" := RFQLine."Unit of Measure Code";
                    PL."Direct Unit Cost" := RFQLine."Unit Cost";
                    PL."Line Amount" := RFQLine."Line Amount";
                    PL.Insert();
                    LineNo := LineNo + 10000;
                end;
            end;
        until RFQLine.Next() = 0;
        Message('Purchase Orders has been created for all lines');

    End;

    var
        //myInt: Interface "Email Connector"
        Email: Codeunit Email;
        EmailMessage: codeunit "Email Message";
        bodytext1: Text;
        CompanyInfo: Record "Company Information";
        VarRecipaints: List of [text];
        Item_Rec: Record Item;

}
