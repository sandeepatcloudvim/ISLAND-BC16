table 50051 "Item Stock Status Info"
{
    // version NAVW18.00,CBR_SS

    CaptionML = ENU = 'Item Stock Status Info',
                ESM = 'Números de lote por búfer de ubicación',
                FRC = 'Numéros lot par tampon zone',
                ENC = 'Item Stock Status Info';

    fields
    {
        field(1; "Item No."; Code[20])
        {
            CaptionML = ENU = 'Item No.',
                        ESM = 'Nº producto',
                        FRC = 'N° d''article',
                        ENC = 'Item No.';
            TableRelation = Item."No.";
        }
        field(2; "Variant Code"; Code[10])
        {
            CaptionML = ENU = 'Variant Code',
                        ESM = 'Cód. variante',
                        FRC = 'Code variante',
                        ENC = 'Variant Code';
        }
        field(3; "Location Code"; Code[10])
        {
            CaptionML = ENU = 'Location Code',
                        ESM = 'Cód. almacén',
                        FRC = 'Code d''emplacement',
                        ENC = 'Location Code';
        }
        field(4; "Zone Code"; Code[10])
        {
            CaptionML = ENU = 'Zone Code',
                        ESM = 'Cód. zona',
                        FRC = 'Code zone',
                        ENC = 'Zone Code';
        }
        field(5; "Bin Code"; Code[20])
        {
            CaptionML = ENU = 'Bin Code',
                        ESM = 'Cód. ubicación',
                        FRC = 'Code de zone',
                        ENC = 'Bin Code';
        }
        field(6; "Lot No."; Code[20])
        {
            CaptionML = ENU = 'Lot No.',
                        ESM = 'Nº lote',
                        FRC = 'N° de lot',
                        ENC = 'Lot No.';
        }
        field(7; "Qty. (Base)"; Decimal)
        {
            CaptionML = ENU = 'Qty. (Base)',
                        ESM = 'Cantidad (Base)',
                        FRC = 'Quantité (base)',
                        ENC = 'Qty. (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(8; Quantity; Decimal)
        {
        }
        field(9; Description; Text[200])
        {
        }
        field(10; "Expiration Date"; Date)
        {
        }
        field(11; "Warranty Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Item No.", "Variant Code", "Location Code", "Zone Code", "Bin Code", "Lot No.")
        {
        }
    }

    fieldgroups
    {
    }
}

