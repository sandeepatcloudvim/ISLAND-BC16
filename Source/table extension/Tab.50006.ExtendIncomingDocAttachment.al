tableextension 50006 ExtendIncomingDocAttachment extends "Incoming Document Attachment"
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
        field(50002; "Variant Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
        field(50003; "Serial No"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'CBR_SS_26042018';
        }
    }

    var
        myInt: Integer;

    procedure NewAttachmentFromILE(ILE: Record "Item Ledger Entry"; SerialNo: Code[20]; LotNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20])
    var
        IncomingDocAttachment: Record "Incoming Document Attachment";
        IncomingDoc: Record "Incoming Document";
    begin
        //CBR_SS..>>
        if ILE."Entry No." <> 0 then begin
            SetRange("Document Table No. Filter", DATABASE::"Item Ledger Entry");
            SetRange("Document No. Filter", Format(ILE."Entry No."));
        end else begin
            SetRange("Serial No", SerialNo);
            SetRange("Lot No.", LotNo);
            SetRange("Item No.", ItemNo);
            SetRange("Variant Code", "Variant Code");
        end;
        NewAttachment;
        if IncomingDoc.Get("Incoming Document Entry No.") then begin
            IncomingDoc."Serial No." := SerialNo;
            IncomingDoc."Lot No." := LotNo;
            IncomingDoc."Item No." := ItemNo;
            IncomingDoc."Variant Code" := VariantCode;
            IncomingDoc.Modify;
        end;
        if IncomingDocAttachment.Get("Incoming Document Entry No.", "Line No.") then begin
            IncomingDocAttachment."Serial No" := SerialNo;
            IncomingDocAttachment."Lot No." := LotNo;
            IncomingDocAttachment."Item No." := ItemNo;
            IncomingDocAttachment."Variant Code" := VariantCode;
            IncomingDocAttachment.Modify;
        end;
        //CBR_SS..<<
    end;

    procedure NewAttachmentFromWareHouseEntry(WareouseEntry: Record "Warehouse Entry"; SerialNo: Code[20]; LotNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20])
    var
        IncomingDocAttachment: Record "Incoming Document Attachment";
        IncomingDoc: Record "Incoming Document";
    begin
        //CBR_SS..>>
        if WareouseEntry.FindFirst then begin
            SetRange("Document Table No. Filter", DATABASE::"Warehouse Entry");
            SetRange("Document No. Filter", Format(WareouseEntry."Entry No."));
        end else begin
            SetRange("Serial No", SerialNo);
            SetRange("Lot No.", LotNo);
            SetRange("Item No.", ItemNo);
            SetRange("Variant Code", "Variant Code");

        end;
        NewAttachment;

        if IncomingDoc.Get("Incoming Document Entry No.") then begin
            IncomingDoc."Serial No." := WareouseEntry."Serial No.";
            IncomingDoc."Lot No." := WareouseEntry."Lot No.";
            IncomingDoc."Item No." := WareouseEntry."Item No.";
            IncomingDoc."Variant Code" := WareouseEntry."Variant Code";
            IncomingDoc.Modify;
        end;
        if IncomingDocAttachment.Get("Incoming Document Entry No.", "Line No.") then begin
            IncomingDocAttachment."Serial No" := WareouseEntry."Serial No.";
            IncomingDocAttachment."Lot No." := WareouseEntry."Lot No.";
            IncomingDocAttachment."Item No." := WareouseEntry."Item No.";
            IncomingDocAttachment."Variant Code" := WareouseEntry."Variant Code";
            IncomingDocAttachment.Modify;
        end;
        //CBR_SS..<<
    end;

    procedure NewAttachmentFrmItemTrackingLines(SerialNo: Code[20]; LotNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20])
    var
        IncomingDocAttachment: Record "Incoming Document Attachment";
        IncomingDoc: Record "Incoming Document";
    begin
        //CBR_SS..>>

        SetRange("Serial No", SerialNo);
        SetRange("Lot No.", LotNo);
        SetRange("Item No.", ItemNo);
        SetRange("Variant Code", "Variant Code");

        NewAttachment;

        if IncomingDoc.Get("Incoming Document Entry No.") then begin
            IncomingDoc."Serial No." := SerialNo;
            IncomingDoc."Lot No." := LotNo;
            IncomingDoc."Item No." := ItemNo;
            IncomingDoc."Variant Code" := VariantCode;
            IncomingDoc.Modify;
        end;
        if IncomingDocAttachment.Get("Incoming Document Entry No.", "Line No.") then begin
            IncomingDocAttachment."Serial No" := SerialNo;
            IncomingDocAttachment."Lot No." := LotNo;
            IncomingDocAttachment."Item No." := ItemNo;
            IncomingDocAttachment."Variant Code" := VariantCode;
            IncomingDocAttachment.Modify;
        end;
        //CBR_SS..<<
    end;
}