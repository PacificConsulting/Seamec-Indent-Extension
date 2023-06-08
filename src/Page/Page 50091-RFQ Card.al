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
                field(Category; Rec.Category)
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Center';
                    //Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Project Code';
                    //Editable = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Insert_Successfully: Boolean;
                Begin
                    Insert_Successfully := false;
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
                                    RFQCatalog.SetRange("Line No.", RFQLine."Line No.");         //PCPL-25/240323
                                    if not RFQCatalog.FindFirst() then begin
                                        RFQCatalog.Init();
                                        RFQCatalog."Sequence No." := 0;
                                        RFQCatalog.Validate("Document No.", RFQLine."Document No.");
                                        RFQCatalog.Validate("Line No.", RFQLine."Line No.");
                                        RFQCatalog.Validate("Vendor No.", ItemVend."Vendor No.");
                                        RFQCatalog.Validate("Item No.", ItemVend."Vendor Item No.");
                                        RFQCatalog.Validate(Quantity, RFQLine.Quantity);
                                        RFQCatalog.Validate(Description, RFQLine.Description);
                                        RFQCatalog.Validate(UOM, RFQLine."Unit of Measure Code");
                                        RFQCatalog.Validate(Comment, RFQLine.Comment);
                                        RFQCatalog.Validate("Line No.", RFQLine."Line No.");
                                        Insert_Successfully := true;     //PCPL-25/240323
                                        RFQCatalog.Insert();
                                    End;
                                until ItemVend.Next() = 0;
                            End Else
                                Error('Vendor catalog does not exist');
                        until RFQLine.Next() = 0
                    else
                        Error('Lines Does not Exist in %1 order', Rec."No.");

                    IF Insert_Successfully then
                        Message('Quotation Insert Successfully');

                    RFQCatalog.Reset();
                    RFQCatalog.SetRange("Document No.", Rec."No.");
                    RFQCatalog.SetCurrentKey("Vendor No.");
                    if RFQCatalog.FindSet() then
                        repeat
                            //RFQCatalog.SetCurrentKey("Vendor No.");
                            //RFQCatalog.SetAscending("Vendor No.", true); 
                            IF RFQCatalog."Vendor No." <> VendorNo then
                                SendMailForVendor(RFQCatalog);
                            VendorNo := RFQCatalog."Vendor No.";
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
                    Rec.TestField("Approval Status", Rec."Approval Status"::Released);           //PCPL-25/240323
                    CreatePO();
                    Rec."Created PO" := true;
                    Rec.Modify();
                end;
            }
            action(RFQReport)
            {
                Caption = 'RFQ Report';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Report;
                trigger OnAction()
                var
                    RFQHdr: Record "RFQ Header";
                Begin
                    RFQHdr.Reset();
                    RFQHdr.SetRange("No.", Rec."No.");
                    if RFQHdr.FindFirst() then
                        Report.RunModal(50100, true, true, RFQHdr);
                End;
            }
        }
        area(Creation)
        {
            action(QuotationList)
            {
                Caption = 'Quotation List';
                ApplicationArea = All;
                Image = Quote;
                trigger OnAction()
                var
                    RFQ_C: Record "RFQ Catalog";
                    RFQLine: Record "RFQ Line";
                begin
                    RFQ_C.SetRange("Document No.", Rec."No.");
                    RFQ_C.SetFilter("Sequence No.", '<>%1', 0);
                    if RFQ_C.FindSet() then begin
                        if Page.RunModal(50092, RFQ_C) = Action::LookupOK then begin
                            RFQ_C.SetRange(Select, true);
                            if RFQ_C.FindSet() then
                                repeat
                                    RFQLine.Reset();
                                    RFQLine.SetRange("Document No.", RFQ_C."Document No.");
                                    RFQLine.SetRange("Line No.", RFQ_C."Line No.");
                                    if RFQLine.FindFirst() then begin
                                        RFQLine."Vendor No." := RFQ_C."Vendor No.";
                                        RFQLine."Unit Cost" := RFQ_C.Price;
                                        //Rec."Line Amount" := Rec.Quantity * rec."Unit Cost";
                                        RFQLine."Line Amount" := RFQ_C."Total Amount";      //PCPL-25/240323 above code comment
                                        RFQLine.validate("Vendor No.", RFQ_C."Vendor No.");
                                        RFQLine.Currency := RFQ_C.Currency;
                                        RFQLine."Total Amount LCY" := RFQ_C."Total Amount LCY";
                                        RFQLine."GST Group Code" := RFQ_C."GST Group Code";
                                        RFQLine.Remark := RFQ_C.Remarks;
                                        RFQLine.Modify();
                                        CurrPage.Update();
                                    end;
                                until RFQ_C.Next() = 0;
                        End;
                    end;
                End;
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
        EncryptedVendname: Text;
        CryptographyManagement: Codeunit "Cryptography Management";
        Url: Text;
        TypeHelper: Codeunit "Type Helper";
        GLSetup: Record 98;
    Begin
        Clear(bodytext1);
        Clear(VarRecipaints);
        GLSetup.Get();
        if RecVendor.GET(RFQ_Catalog."Vendor No.") then begin
            RecItem.Get(RFQ_Catalog."Item No.");
            CompanyInfo.GET;
            RFQHdr.GET(RFQ_Catalog."Document No.");
            IF RFQLine.GET(RFQ_Catalog."Document No.", RFQ_Catalog."Line No.") then;

            URL := GLSetup."RFQ URL" + 'rfqdetail.aspx?param1=%1&param2=%2&param3=%3&param4=%4';
            //URL := 'http://localhost:54939/rfqdetail.aspx?param1=%1&param2=%2';
            //'http://localhost:54939/rfqdetail.aspx?param1=value1&param2=value2'

            EncryptedDoc := CryptographyManagement.EncryptText(RFQ_Catalog."Document No.");
            EncryptedVendname := CryptographyManagement.EncryptText(RecVendor.Name);
            EncryptedVend := CryptographyManagement.EncryptText(RecVendor."No.");


            EncryptedDoc := CryptographyManagement.EncryptText(RFQ_Catalog."Document No.").Replace('+', 'plustext');
            EncryptedVend := CryptographyManagement.EncryptText(RecVendor."No.").Replace('+', 'plustext');
            EncryptedVend := CryptographyManagement.EncryptText(RecVendor.Name).Replace('+', 'plustext');

            DecryptedValue1 := StrSubstNo(URL, CryptographyManagement.EncryptText(RFQ_Catalog."Document No.").Replace('+', 'plustext'), CryptographyManagement.EncryptText(RecVendor.Name).Replace('+', 'plustext'), CryptographyManagement.EncryptText(RecVendor."No.").Replace('+', 'plustext'), CryptographyManagement.EncryptText('temp').Replace('+', 'plustext'));
            //DecryptedValue1 := StrSubstNo(URL, CryptographyManagement.EncryptText(RFQ_Catalog."Document No."), CryptographyManagement.EncryptText(RecVendor.Name),CryptographyManagement.EncryptText(RecVendor."No."));
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
            // bodytext1 += ('<th> Web Link </th>');
            RFQC.Reset();
            RFQC.SetRange("Document No.", RFQ_Catalog."Document No.");
            RFQC.SetRange("Vendor No.", RFQ_Catalog."Vendor No.");
            if RFQC.FindSet() then
                repeat
                    RecItem.Reset();
                    RecItem.Get(RFQC."Item No.");
                    BodyText1 += '</tr>';
                    BodyText1 += '<tr>';
                    BodyText1 += ('<td>' + FORMAT(RFQHdr.Date) + '</td>');
                    BodyText1 += ('<td>' + FORMAT(RFQC."Document No.") + '</td>');
                    BodyText1 += ('<td>' + Format(RFQC."Item No.") + '</td>');
                    BodyText1 += ('<td>' + RecItem.Description + '</td>');
                    BodyText1 += ('<td>' + Format(RFQC."Vendor No.") + '</td>');
                    BodyText1 += ('<td>' + FORMAT(RFQC.Quantity) + '</td>');
                    BodyText1 += ('<td>' + FORMAT(RFQC.UOM) + '</td>');
                    // BodyText1 += ('<td>' + '<a href=' + DecryptedValue + '/">Click to web Link!</a>' + '</td>');
                    BodyText1 += '</tr>';
                until RFQC.Next() = 0;
            BodyText1 += '</table>';
            bodytext1 += ('<br><Br>');
            bodytext1 += ('<th> Vendor Name : ' + RecVendor.Name + '</th>');
            bodytext1 += ('<br><Br>');
            bodytext1 += ('<th> Please Click on Below  Web Link : </th>');
            bodytext1 += ('<br><Br>');
            BodyText1 += ('<td>' + '<a href=' + DecryptedValue + '/">Web Link!</a>' + '</td>');
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
            //VarRecipaints.Add('kamalkant@pacificconsulting.in');
            // VarRecipaints.Add('nirmal.wagh@pacificconsulting.in');
            VarRecipaints.Add(RecVendor."E-Mail");
            //VarRecipaints.Add(RecVendor."E-Mail");
            // EmailMessage.Create(VarRecipaints, 'Request For Quote : ' + RecItem.Description, bodytext1, true);
            VarCC.Add(GLSetup."RFQ CC Mail"); //PCPL-0070--30Mar2023
            EmailMessage.Create(VarRecipaints, 'Request For Quote : ' /*+ RecItem.Description*/, bodytext1, true, VarCC, VarBCC); //PCPL-0070--30Mar2023
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
        Rec_Vendor: Record Vendor;
        Purch_Hdr: Record "Purchase Header";
        Purch_Line: Record "Purchase Line";
        PurchOrdNo: Code[1024];
        PurchOrdNo_txt: Text[1024];
        IndentHdr: Record "Indent Header";
    Begin
        PurchSetup.GET;
        RFQLine.reset;
        RFQLine.SetRange("Document No.", Rec."No.");
        RFQLine.SetFilter("Vendor No.", '<>%1', '');
        RFQLine.SetCurrentKey("Vendor No.");
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
                        PH.Validate("Location Code", Rec."Location Code");

                        //PCPL-0070 06June23 <<
                        IndentHdr.Reset();
                        IndentHdr.SetRange("No.", Rec."No.");
                        if IndentHdr.FindFirst() then
                            IndentHdr."Po Created" := true;
                        IndentHdr.Modify();
                        //PCPL-0070 06June23 >>

                        PH.Insert();
                        Clear(Purch_Hdr);
                        IF Purch_Hdr.GET(PH."Document Type", PH."No.") then;
                        Purch_Hdr.Validate("Posting Date", Today);
                        Purch_Hdr.validate("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                        Purch_Hdr.Validate("Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code");
                        Purch_Hdr."Create PO by Indent" := true;
                        Purch_Hdr."RFQ Indent No." := Rec."No.";
                        Purch_Hdr."Order Date" := Today;
                        Purch_Hdr.Modify(true);
                        // Message('Purchase Order %1 has been created', PH."No.");
                        PL.init;
                        PL."Document No." := PH."No.";
                        PL."Document Type" := PH."Document Type";
                        PL."Line No." := LineNo;
                        PL.Insert(true);
                        Clear(Purch_Line);
                        if Purch_Line.Get(PL."Document Type", PL."Document No.", PL."Line No.") then;
                        Purch_Line.Type := Purch_Line.Type::Item;
                        Purch_Line.Validate("Buy-from Vendor No.", PH."Buy-from Vendor No.");
                        Purch_Line.Validate("Pay-to Vendor No.", PH."Pay-to Vendor No.");
                        Purch_Line."RFQ Remarks" := RFQLine.Remark;
                        Purch_Line.Validate("No.", RFQLine."No.");
                        IF RFQLine."Location Code" <> '' then
                            Purch_Line.Validate("Location Code", RFQLine."Location Code")
                        else
                            Purch_Line.Validate("Location Code", Purch_Hdr."Location Code");
                        if Item_Rec.GET(Purch_Line."No.") then;
                        Purch_Line.Description := Item_Rec.Description;
                        Purch_Line."Description 2" := Item_Rec."Description 2";
                        Purch_Line.Quantity := RFQLine.Quantity;
                        if RFQLine."GST Group Code" <> '--Select Tax Group--' then
                            Purch_Line.Validate("GST Group Code", RFQLine."GST Group Code");
                        Purch_Line.Validate("Unit of Measure Code", RFQLine."Unit of Measure Code");
                        Purch_Line."Line Amount" := RFQLine."Line Amount";
                        Purch_Line."Direct Unit Cost" := RFQLine."Unit Cost";
                        Purch_Line."Indent No." := Rec."No.";
                        Purch_Line."RFQ Remarks" := RFQLine.Remark;
                        Purch_Line.Modify(true);
                        LastVendorNo := PH."Buy-from Vendor No.";
                        LineNo += LineNo + 10000;
                    End ELse begin
                        PL.init;
                        PL.Validate("Document No.", PH."No.");
                        PL.Validate("Document Type", PH."Document Type");
                        PL."Line No." := LineNo;
                        PL.Insert(true);
                        Clear(Purch_Line);
                        if Purch_Line.Get(PL."Document Type", PL."Document No.", PL."Line No.") then;
                        Purch_Line.Type := Purch_Line.Type::Item;
                        Purch_Line."RFQ Remarks" := RFQLine.Remark;
                        Purch_Line.validate("No.", RFQLine."No.");
                        if Item_Rec.GET(Purch_Line."No.") then;
                        Purch_Line.Description := Item_Rec.Description;
                        Purch_Line."Description 2" := Item_Rec."Description 2";
                        IF RFQLine."Location Code" <> '' then
                            Purch_Line.Validate("Location Code", RFQLine."Location Code")
                        else
                            Purch_Line.Validate("Location Code", Purch_Hdr."Location Code");
                        Purch_Line.Validate(Quantity, RFQLine.Quantity);
                        if RFQLine."GST Group Code" <> '--Select Tax Group--' then
                            Purch_Line.Validate("GST Group Code", RFQLine."GST Group Code");
                        Purch_Line.Validate("Unit of Measure Code", RFQLine."Unit of Measure Code");
                        Purch_Line."Direct Unit Cost" := RFQLine."Unit Cost";
                        Purch_Line."Line Amount" := RFQLine."Line Amount";
                        Purch_Line."Indent No." := Rec."No.";
                        Purch_Line."RFQ Remarks" := RFQLine.Remark;
                        Purch_Line.Modify(true);
                        LineNo := LineNo + 10000;
                    end;
                end;
            end;
            PurchOrdNo := PurchOrdNo + PH."No." + '|';
        until RFQLine.Next() = 0;
        PurchOrdNo_txt := DelStr(PurchOrdNo, StrLen(PurchOrdNo), 1);
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
        RFQC: Record "RFQ Catalog";
        VarCC: List of [Text]; //PCPL-0070--30Mar2023
        VarBCC: List of [Text];
}
