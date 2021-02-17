report 50004 "Pick List_CBR"
{
    // version NAVW111.00,NAVNA11.00,CBR_SS

    // CBR_SS : 11/05/2018 : Added code to get Item Details
    DefaultLayout = RDLC;
    RDLCLayout = './Pick List_CBR.rdlc';

    CaptionML = ENU = 'Pick Instruction',
                ESM = 'Instrucción picking',
                FRC = 'Instruction prélèvement',
                ENC = 'Pick Instruction';

    dataset
    {
        dataitem(CopyLoop; "Integer")
        {
            DataItemTableView = SORTING(Number);
            column(Number; Number)
            {
            }
            column(CompanyNameText; CompNameText)
            {
            }
            column(DateText; DateTxt)
            {
            }
            column(TotalCaptionLbl; TotalCaptionLbl)
            {
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemTableView = SORTING("Document Type", "No.") WHERE("Document Type" = CONST(Order));
                RequestFilterFields = "No.";
                column(No_SalesHeader; "No.")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_SalesHeader; "Sell-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(SO_Num; "Sales Header"."No.")
                {
                }
                column(ShipmentDate; "Sales Header"."Shipment Date")
                {
                }
                column(ExternalDocNum; "Sales Header"."External Document No.")
                {
                }
                column(ShipToName1; "Sales Header"."Ship-to Name")
                {
                }
                column(ShipToName2; "Sales Header"."Ship-to Name 2")
                {
                }
                column(ShipToAddress1; "Sales Header"."Ship-to Address")
                {
                }
                column(ShipToAddress2; "Sales Header"."Ship-to Address 2")
                {
                }
                column(ShiipToCity; "Sales Header"."Ship-to City")
                {
                }
                column(ShipToCounty; "Sales Header"."Ship-to County")
                {
                }
                column(ShipToZip; "Sales Header"."Ship-to Post Code")
                {
                }
                column(ShipToCountry; "Sales Header"."Ship-to Country/Region Code")
                {
                }
                column(ShipmentMethjodCode; "Sales Header"."Shipment Method Code")
                {
                }
                column(CustomerName_SalesHeader; "Sell-to Customer Name")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_SalesHeader; "Sales Header"."Posting Date")
                {
                }
                dataitem("Sales Line"; "Sales Line")
                {
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));
                    column(LineNo_SalesLine; "Line No.")
                    {
                    }
                    column(ItemNo_SalesLine; "No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_SalesLine; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VariantCode_SalesLine; "Variant Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocationCode_SalesLine; "Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_SalesLine; "Bin Code")
                    {
                        IncludeCaption = true;
                    }
                    column(ShipmentDate_SalesLine; FORMAT("Shipment Date"))
                    {
                    }
                    column(Quantity_SalesLine; Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(UnitOfMeasure_SalesLine; "Unit of Measure")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityToShip_SalesLine; "Qty. to Ship")
                    {
                        IncludeCaption = true;
                    }
                    column(QuantityShipped_SalesLine; "Quantity Shipped")
                    {
                        IncludeCaption = true;
                    }
                    column(QtyToAsm; QtyToAsm)
                    {
                    }
                    column(MaasterUPC; ItemRec.MasterUPC)
                    {
                    }
                    column(LotNoValue; LotNoValue)
                    {
                    }
                    dataitem("Assembly Line"; "Assembly Line")
                    {
                        DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                        column(No_AssemblyLine; "No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_AssemblyLine; Description)
                        {
                            IncludeCaption = true;
                        }
                        column(VariantCode_AssemblyLine; "Variant Code")
                        {
                            IncludeCaption = true;
                        }
                        column(Quantity_AssemblyLine; Quantity)
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityPer_AssemblyLine; "Quantity per")
                        {
                            IncludeCaption = true;
                        }
                        column(UnitOfMeasure_AssemblyLine; GetUOM("Unit of Measure Code"))
                        {
                        }
                        column(LocationCode_AssemblyLine; "Location Code")
                        {
                            IncludeCaption = true;
                        }
                        column(BinCode_AssemblyLine; "Bin Code")
                        {
                            IncludeCaption = true;
                        }
                        column(QuantityToConsume_AssemblyLine; "Quantity to Consume")
                        {
                            IncludeCaption = true;
                        }

                        trigger OnPreDataItem();
                        begin
                            if not AsmExists then
                                CurrReport.BREAK;
                            SETRANGE("Document Type", AsmHeader."Document Type");
                            SETRANGE("Document No.", AsmHeader."No.");
                        end;
                    }

                    trigger OnAfterGetRecord();
                    var
                        AssembleToOrderLink: Record "Assemble-to-Order Link";
                    begin
                        AssembleToOrderLink.RESET;
                        AssembleToOrderLink.SETCURRENTKEY(Type, "Document Type", "Document No.", "Document Line No.");
                        AssembleToOrderLink.SETRANGE(Type, AssembleToOrderLink.Type::Sale);
                        AssembleToOrderLink.SETRANGE("Document Type", "Document Type");
                        AssembleToOrderLink.SETRANGE("Document No.", "Document No.");
                        AssembleToOrderLink.SETRANGE("Document Line No.", "Line No.");
                        AsmExists := AssembleToOrderLink.FINDFIRST;
                        QtyToAsm := 0;
                        if AsmExists then
                            if AsmHeader.GET(AssembleToOrderLink."Assembly Document Type", AssembleToOrderLink."Assembly Document No.") then
                                QtyToAsm := AsmHeader."Quantity to Assemble"
                            else
                                AsmExists := false;

                        if ItemRec.GET("Sales Line"."No.") then;  //CBR_SS_11052018

                        //CBR_SS_150518 <<
                        CLEAR(LotNoValue);
                        ReservEntry.RESET;
                        ReservEntry.SETRANGE("Source ID", "Sales Line"."Document No.");
                        ReservEntry.SETRANGE("Source Ref. No.", "Sales Line"."Line No.");
                        ReservEntry.SETRANGE("Item No.", "Sales Line"."No.");
                        if ReservEntry.FINDFIRST then
                            repeat
                                LotNoValue := ReservEntry."Lot No.";
                            until ReservEntry.NEXT = 0;

                        TracSpec.RESET;
                        TracSpec.SETRANGE("Source ID", "Sales Line"."Document No.");
                        TracSpec.SETRANGE("Source Ref. No.", "Sales Line"."Line No.");
                        TracSpec.SETRANGE("Item No.", "Sales Line"."No.");
                        if TracSpec.FINDFIRST then
                            repeat
                                LotNoValue := TracSpec."Lot No.";
                            until TracSpec.NEXT = 0;

                        //CBR_SS_150518 >>
                    end;
                }
            }

            trigger OnPreDataItem();
            begin
                SETRANGE(Number, 1, NoOfCopies + 1);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    CaptionML = ENU = 'Options',
                                ESM = 'Opciones',
                                FRC = 'Options',
                                ENC = 'Options';
                    field("No of Copies"; NoOfCopies)
                    {
                        ApplicationArea = Advanced;
                        CaptionML = ENU = 'No of Copies',
                                    ESM = 'N.º copias',
                                    FRC = 'Nombre de copies',
                                    ENC = 'No of Copies';
                        ToolTipML = ENU = 'Specifies how many copies of the document to print.',
                                    ESM = 'Especifica cuántas copias del documento se van a imprimir.',
                                    FRC = 'Spécifie le nombre de copies du document à imprimer.',
                                    ENC = 'Specifies how many copies of the document to print.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        label(OrderPickingListCaption; ENU = 'Pick Instruction',
                                      ESM = 'Instrucción picking',
                                      FRC = 'Instruction prélèvement',
                                      ENC = 'Pick Instruction')
        label(PageCaption; ENU = 'Page',
                          ESM = 'Pág.',
                          FRC = 'Page',
                          ENC = 'Page')
        label(ItemNoCaption; ENU = 'Item  No.',
                            ESM = 'Nº producto',
                            FRC = 'N° article',
                            ENC = 'Item  No.')
        label(OrderNoCaption; ENU = 'Order No.',
                             ESM = 'Nº pedido',
                             FRC = 'N° commande',
                             ENC = 'Order No.')
        label(CustomerNoCaption; ENU = 'Customer No.',
                                ESM = 'Nº cliente',
                                FRC = 'N° de client',
                                ENC = 'Customer No.')
        label(CustomerNameCaption; ENU = 'Customer Name',
                                  ESM = 'Nombre cliente',
                                  FRC = 'Nom client',
                                  ENC = 'Customer Name')
        label(QtyToAssembleCaption; ENU = 'Quantity to Assemble',
                                   ESM = 'Cantidad a ensamblar',
                                   FRC = 'Quantité à assembler',
                                   ENC = 'Quantity to Assemble')
        label(QtyAssembledCaption; ENU = 'Quantity Assembled',
                                  ESM = 'Cantidad ensamblada',
                                  FRC = 'Quantité assemblée',
                                  ENC = 'Quantity Assembled')
        label(ShipmentDateCaption; ENU = 'Shipment Date',
                                  ESM = 'Fecha envío',
                                  FRC = 'Date de livraison',
                                  ENC = 'Shipment Date')
        label(QtyPickedCaption; ENU = 'Quantity Picked',
                               ESM = 'Cantidad preparada',
                               FRC = 'Quantité prélevée',
                               ENC = 'Quantity Picked')
        label(UOMCaption; ENU = 'Unit of Measure',
                         ESM = 'Unidad medida',
                         FRC = 'Unité de mesure',
                         ENC = 'Unit of Measure')
        label(QtyConsumedCaption; ENU = 'Quantity Consumed',
                                 ESM = 'Cantidad consumida',
                                 FRC = 'Quantité utilisée',
                                 ENC = 'Quantity Consumed')
        label(CopyCaption; ENU = 'Copy',
                          ESM = 'Copiar',
                          FRC = 'Copier',
                          ENC = 'Copy')
    }

    trigger OnPreReport();
    begin
        DateTxt := FORMAT(TODAY);
        CompNameText := COMPANYNAME;
    end;

    var
        AsmHeader: Record "Assembly Header";
        NoOfCopies: Integer;
        DateTxt: Text;
        CompNameText: Text;
        QtyToAsm: Decimal;
        AsmExists: Boolean;
        TotalCaptionLbl: Label 'Total';
        ItemRec: Record Item;
        LotNoValue: Code[20];
        ReservEntry: Record "Reservation Entry";
        TracSpec: Record "Tracking Specification";

    local procedure GetUOM(UOMCode: Code[10]): Text;
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.GET(UOMCode) then
            exit(UnitOfMeasure.Description);
        exit(UOMCode);
    end;

    [Scope('Personalization')]
    procedure InitializeRequest(NewNoOfCopies: Integer);
    begin
        NoOfCopies := NewNoOfCopies;
    end;
}

