tableextension 50005 ExtendIncomingDocument extends "Incoming Document"
{
    fields
    {
        field(50000; "Lot No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
        field(50001; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
        field(50002; "Variant Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
        field(50003; "Serial No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
    }

    var
        myInt: Integer;

    procedure ShowCard_ILEAndWarehouseentry(SerialNo: Code[20]; LotNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20])
    begin
        //CBR_SS..>>
        Reset;
        SetRange("Serial No.", SerialNo);
        SetRange("Lot No.", LotNo);
        SetRange("Item No.", ItemNo);
        SetRange("Variant Code", VariantCode);
        if not FindFirst then
            exit;
        SetRecFilter;
        PAGE.Run(PAGE::"Incoming Document", Rec);
        //CBR_SS..>>
    end;

    procedure ShowCardCBR(DocumentNo: Code[20])
    begin
        Reset;
        SetRange("Document No.", DocumentNo);
        if not FindFirst then
            exit;
        SetRecFilter;
        PAGE.Run(PAGE::"Incoming Document", Rec);
    end;
}