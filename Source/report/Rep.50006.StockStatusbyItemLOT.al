report 50006 "Stock Status by Item - LOT"
{
    // version NAVNA10.00,CBR_SS

    DefaultLayout = RDLC;
    RDLCLayout = './Stock Status by Item - LOT.rdlc';
    CaptionML = ENU = 'Stock Status by Item-LOT',
                ESM = 'Estado/antigüedad nº serie',
                FRC = 'État/classement chronologique des n° de série',
                ENC = 'Serial Number Status/Aging';

    dataset
    {
        dataitem(Item; Item)
        {
            CalcFields = Inventory;
            DataItemTableView = WHERE("Item Tracking Code" = FILTER(<> ''));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Vendor No.", "Lot No. Filter", "Location Filter", "Bin Filter";
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(TIME; TIME)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(STRSUBSTNO_Text000_WORKDATE_; STRSUBSTNO(Text000, WORKDATE))
            {
            }
            column(Item_TABLECAPTION__________ItemFilter; Item.TABLECAPTION + ': ' + ItemFilter)
            {
            }
            column(ItemFilter; ItemFilter)
            {
            }
            column(Item__No__; "No.")
            {
            }
            column(Item_Description; Description)
            {
            }
            column(Item__Base_Unit_of_Measure_; "Base Unit of Measure")
            {
            }
            column(Item_Date_Filter; "Date Filter")
            {
            }
            column(Item_Location_Filter; "Location Filter")
            {
            }
            column(Item_Variant_Filter; "Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter; "Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter; "Global Dimension 2 Filter")
            {
            }
            column(Serial_Number_Status_AgingCaption; Serial_Number_Status_AgingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaptions; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Item_DescriptionCaption; FIELDCAPTION(Description))
            {
            }
            column(DaysAgedCaption; DaysAgedCaptionLbl)
            {
            }
            column(UnitCostCaption; UnitCostCaptionLbl)
            {
            }
            column(Tot_ILE_Qty; Inventory)
            {
            }
            column(UnitCost; "Unit Cost")
            {
            }
            dataitem("Warehouse Entry"; "Warehouse Entry")
            {
                DataItemLink = "Item No." = FIELD("No."), "Lot No." = FIELD("Lot No. Filter"), "Registering Date" = FIELD("Date Filter"), "Location Code" = FIELD("Location Filter"), "Bin Code" = FIELD("Bin Filter");
                DataItemTableView = SORTING("Location Code", "Item No.", "Variant Code", "Zone Code", "Bin Code", "Lot No.");
                column(WE_Lot_No_; "Lot No.")
                {
                }
                column(WE_Bin_Code; "Bin Code")
                {
                }
                column(WE_Quantity; "Qty. (Base)")
                {
                }
                column(WE_LocationCode; "Location Code")
                {
                }
                column(WE_PostingDate; "Registering Date")
                {
                }
                column(WE_ExpirationDate; "Expiration Date")
                {
                }
                column(WE_WarrantyDate; "Warranty Date")
                {
                }
                column(WE_UoM; "Unit of Measure Code")
                {
                }
                column(DaysAged; DaysAged)
                {
                }
                column(TotalDaysAged; TotalDaysAged)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    DaysAged := WORKDATE - "Registering Date";
                    TotalDaysAged := TotalDaysAged + DaysAged;
                end;

                trigger OnPreDataItem();
                begin
                    TotalDaysAged := 0;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        ItemFilter := Item.GETFILTERS;
        with "Warehouse Entry" do begin
            SETCURRENTKEY("Item No.");
            SETFILTER("Location Code", Item.GETFILTER("Location Filter"));
            SETFILTER("Bin Code", Item.GETFILTER("Bin Filter"));
        end;
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemFilter: Text;
        DaysAged: Integer;
        TotalDaysAged: Integer;
        AverageAge: Decimal;
        Text000: TextConst ENU = '(As of %1)', ESM = '(Hasta el %1)', FRC = '(A partir de %1)', ENC = '(As of %1)';
        UnitCost: Decimal;
        Serial_Number_Status_AgingCaptionLbl: TextConst ENU = 'Serial Number Status/Aging', ESM = 'Estado/antigüedad nº serie', FRC = 'État/classement chronologique des n° de série', ENC = 'Serial Number Status/Aging';
        CurrReport_PAGENOCaptionLbl: TextConst ENU = 'Page', ESM = 'Pág.', FRC = 'Page', ENC = 'Page';
        DaysAgedCaptionLbl: TextConst ENU = 'Days Aged', ESM = 'Días vencidos', FRC = 'Classement chronologique des jours', ENC = 'Days Aged';
        UnitCostCaptionLbl: TextConst ENU = 'Unit Cost', ESM = 'Costo unitario', FRC = 'Coût unitaire', ENC = 'Unit Cost';
}

