page 50054 "Item Stock Status Info"
{
    // version CBR_SS

    Caption = 'Item Stock Status Info';
    Editable = false;
    PageType = List;
    SourceTable = "Item Stock Status Info";

    layout
    {
        area(content)
        {
            repeater(Control7)
            {
                field("Item No."; "Item No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU = 'Specifies the item that exists as lot numbers in the bin.',
                                ESM = 'Especifica el producto que existe como números de lote en la ubicación.',
                                FRC = 'Spécifie l''article existant comme numéros de lot dans la zone.',
                                ENC = 'Specifies the item that exists as lot numbers in the bin.';
                }
                field(Description; Description)
                {
                }
                field("Zone Code"; "Zone Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU = 'Specifies the zone that is assigned to the bin where the lot number exists.',
                                ESM = 'Especifica la zona asignada a la ubicación donde existe el número de lote.',
                                FRC = 'Spécifie la zone attribuée à la zone où le numéro de lot existe.',
                                ENC = 'Specifies the zone that is assigned to the bin where the lot number exists.';
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Bin Code"; "Bin Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU = 'Specifies the bin where the lot number exists.',
                                ESM = 'Especifica la ubicación donde existe el número de lote.',
                                FRC = 'Spécifie la zone où le numéro de lot existe.',
                                ENC = 'Specifies the bin where the lot number exists.';
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = Warehouse;
                    ToolTipML = ENU = 'Specifies the lot number that exists in the bin.',
                                ESM = 'Especifica el número de lote que existe en la ubicación.',
                                FRC = 'Spécifie le numéro du lot présent dans la zone.',
                                ENC = 'Specifies the lot number that exists in the bin.';
                }
                field("Expiration Date"; "Expiration Date")
                {
                }
                field("Warranty Date"; "Warranty Date")
                {
                }
                field("Qty. (Base)"; "Qty. (Base)")
                {
                    ApplicationArea = Warehouse;
                    CaptionML = ENU = 'Quantity On Hand',
                                ESM = 'Cantidad (Base)',
                                FRC = 'Quantité (base)',
                                ENC = 'Quantity On Hand';
                    ToolTipML = ENU = 'Specifies how many items with the lot number exist in the bin.',
                                ESM = 'Especifica cuántos productos con el número de lote existen en la ubicación.',
                                FRC = 'Spécifie le nombre d''articles présents dans la zone avec ce numéro de lot.',
                                ENC = 'Specifies how many items with the lot number exist in the bin.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Data")
            {
                Image = UpdateShipment;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    FillTempTable2;
                end;
            }
        }
    }

    var
        ItemFilter: Text;
        ExpirationDate: Date;
        WarrantryDate: Date;
        ShowDialog: Dialog;

    local procedure FillTempTable();
    var
        LotNosByBinCode: Query "Item Stock Status Info";
        Itemrec: Record Item;
        ItemLitWiseStatus: Record "Item Stock Status Info";
    begin
        //LotNosByBinCode.SETRANGE(Item_No,GETRANGEMIN("Item No."));LS-S15
        //LotNosByBinCode.SETRANGE(Item_No,'LS-S15');

        // LotNosByBinCode.SETRANGE(Variant_Code,GETRANGEMIN("Variant Code"));
        // LotNosByBinCode.SETRANGE(Location_Code,GETRANGEMIN("Location Code"));

        //DELETEALL;
        if ItemFilter <> '' then
            LotNosByBinCode.SETFILTER(LotNosByBinCode.Item_No, ItemFilter);
        ShowDialog.OPEN('Updating entries..');
        LotNosByBinCode.OPEN;
        while LotNosByBinCode.READ do begin
            INIT;
            "Item No." := LotNosByBinCode.Item_No;
            "Variant Code" := LotNosByBinCode.Variant_Code;
            "Location Code" := LotNosByBinCode.Location_Code;
            "Zone Code" := LotNosByBinCode.Zone_Code;
            "Bin Code" := LotNosByBinCode.Bin_Code;
            "Lot No." := LotNosByBinCode.Lot_No;

            "Qty. (Base)" := LotNosByBinCode.Sum_Qty_Base;
            if Itemrec.GET(LotNosByBinCode.Item_No) then begin
                GetExpirationDate(LotNosByBinCode);
                "Expiration Date" := ExpirationDate;
                "Warranty Date" := WarrantryDate;
                Description := Itemrec.Description;
            end;
            if INSERT then;
        end;
        ShowDialog.CLOSE;
    end;

    local procedure GetExpirationDate(ItemLot: Query "Item Stock Status Info");
    var
        WarehouseEntry: Record "Warehouse Entry";
    begin
        ExpirationDate := 0D;
        WarrantryDate := 0D;
        WarehouseEntry.RESET;
        WarehouseEntry.SETRANGE("Item No.", ItemLot.Item_No);
        WarehouseEntry.SETRANGE("Location Code", ItemLot.Location_Code);
        WarehouseEntry.SETRANGE("Bin Code", ItemLot.Bin_Code);
        WarehouseEntry.SETRANGE("Lot No.", ItemLot.Lot_No);
        if WarehouseEntry.FINDFIRST then begin
            ExpirationDate := WarehouseEntry."Expiration Date";
            WarrantryDate := WarehouseEntry."Warranty Date";
        end;
    end;

    local procedure FillTempTable2();
    var
        LotNosByBinCode: Query "Item Stock Status Info";
        Itemrec: Record Item;
        ItemLitWiseStatus: Record "Item Stock Status Info";
    begin
        //LotNosByBinCode.SETRANGE(Item_No,GETRANGEMIN("Item No."));LS-S15
        //LotNosByBinCode.SETRANGE(Item_No,'LS-S15');

        // LotNosByBinCode.SETRANGE(Variant_Code,GETRANGEMIN("Variant Code"));
        // LotNosByBinCode.SETRANGE(Location_Code,GETRANGEMIN("Location Code"));

        DELETEALL;
        if ItemFilter <> '' then
            LotNosByBinCode.SETFILTER(LotNosByBinCode.Item_No, ItemFilter);
        ShowDialog.OPEN('Updating entries..');
        LotNosByBinCode.OPEN;
        while LotNosByBinCode.READ do begin
            ItemLitWiseStatus.INIT;
            ItemLitWiseStatus."Item No." := LotNosByBinCode.Item_No;
            ItemLitWiseStatus."Variant Code" := LotNosByBinCode.Variant_Code;
            ItemLitWiseStatus."Location Code" := LotNosByBinCode.Location_Code;
            ItemLitWiseStatus."Zone Code" := LotNosByBinCode.Zone_Code;
            ItemLitWiseStatus."Bin Code" := LotNosByBinCode.Bin_Code;
            ItemLitWiseStatus."Lot No." := LotNosByBinCode.Lot_No;

            ItemLitWiseStatus."Qty. (Base)" := LotNosByBinCode.Sum_Qty_Base;
            if Itemrec.GET(LotNosByBinCode.Item_No) then begin
                GetExpirationDate(LotNosByBinCode);
                ItemLitWiseStatus."Expiration Date" := ExpirationDate;
                ItemLitWiseStatus."Warranty Date" := WarrantryDate;
                ItemLitWiseStatus.Description := Itemrec.Description;
            end;
            if ItemLitWiseStatus.INSERT then;
        end;
        ShowDialog.CLOSE;
    end;
}

