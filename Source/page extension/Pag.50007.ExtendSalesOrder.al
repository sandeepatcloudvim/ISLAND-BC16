pageextension 50007 ExtendSalesOrder extends "Sales Order"
{
    layout
    {
        addafter("Promised Delivery Date")
        {
            field("Cancellation Date"; "Cancellation Date")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Campaign No.")
        {
            field("Shipping Window"; "Shipping Window")
            {
                ApplicationArea = All;
            }
            field("PRO#"; "PRO#")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Work Description")
        {
            field("Created By User Name"; "Created By User Name")
            {
                Caption = 'Created By';
                ApplicationArea = All;
            }
            field("Creation Time"; "Creation Time")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Create &Warehouse Shipment")
        {
            action(CreateTrackingLine)
            {
                Caption = 'Create Tracking Line';
                Image = Track;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                begin
                    InsertTrackingLines;
                end;
            }
        }
        addafter("Pick Instruction")
        {
            action("Bill of Lading")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Bill of Lading';
                Ellipsis = true;
                Image = Print;
                ToolTip = 'Prepare to registers actual item quantities or time used in connection with the sales order. For example, the document can be used by staff who perform any kind of processing work in connection with the sales order. It can also be exported to Excel if you need to process the sales line data further.';
            }
            action("Prepare B/L")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Prepare B/L';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Prepare to registers actual item quantities or time used in connection with the sales order. For example, the document can be used by staff who perform any kind of processing work in connection with the sales order. It can also be exported to Excel if you need to process the sales line data further.';

                trigger OnAction()
                begin
                    //CBR_SS_12/19/2019..>>
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50003, true, false, Rec);
                    Reset;
                    //CBR_SS_12/19/2019..<<
                end;
            }
        }
    }

    var
        myInt: Integer;

    local procedure "//CBR_SS"()
    begin
    end;

    local procedure GetReservationQty(SalesLine: Record "Sales Line"; ILE: Record "Item Ledger Entry"): Decimal
    var
        ReservationQty: Decimal;
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", SalesLine."No.");
        ReservEntry.SetRange("Location Code", SalesLine."Location Code");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Lot No.", ILE."Lot No.");
        if ReservEntry.FindSet then
            repeat
                ReservationQty += ReservEntry."Quantity (Base)";
            until ReservEntry.Next = 0;
        exit(ReservationQty)
    end;

    local procedure InsertTrackingLines()
    var
        RecSalesLine: Record "Sales Line";
        ReservationEntry: Record "Reservation Entry";
        ErrorTable: Record "Error Message" temporary;
        ItemRec: Record Item;
        Text001: Label 'Item tracking Lines for the Sales Order: %1  has been created successfully';
        Text002: Label 'Would you like to auto fill the tracking line for the sales Order No %1';
    begin
        //CBR_SS_02042018..<<
        TestField(Status, Status::Open);
        if not Confirm(Text002, false, "No.") then
            exit;
        DeleteReservationEntry(Rec);  // Clean the old Resrevation for the Order

        RecSalesLine.Reset;
        RecSalesLine.SetRange("Document Type", RecSalesLine."Document Type"::Order);
        RecSalesLine.SetRange("Document No.", "No.");
        RecSalesLine.SetRange(Type, RecSalesLine.Type::Item);
        RecSalesLine.SetFilter("No.", '<>%1', '*@ZZ*');
        RecSalesLine.SetFilter("Qty. to Ship", '>%1', 0);
        if RecSalesLine.FindSet then
            repeat
                if ItemRec.Get(RecSalesLine."No.") then begin
                    if ItemRec.Type = ItemRec.Type::Inventory then begin
                        UpdateSalesLineWithFullCasePackQty(RecSalesLine);
                        AutoFillTrackingLines(RecSalesLine, ErrorTable);
                    end;
                end;
            until RecSalesLine.Next = 0;
        Message('Tracking lines for Sales order : %1 have been created successfully', "No.");

        //CBR_SS_02042018..<<
    end;

    local procedure UpdateSalesLineWithFullCasePackQty(var SalesLine: Record "Sales Line"): Boolean
    var
        AvablLotQty: Decimal;
        ReservEntry: Record "Reservation Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LotQty: Decimal;
        QtyChek: Boolean;
        QtyChek1: Boolean;
        TotalILEQty: Decimal;
        ReserveQty: Decimal;
        fieldRef: FieldRef;
        RecRef: RecordRef;
        SalesLineRec: Record "Sales Line";
        CasePackQty: Decimal;
        ItemRec: Record Item;
        IUoM: Record "Item Unit of Measure";
        CurrLotNo: Code[20];
        ILERemainingQty: Decimal;
        AvaliablecasePackQty: Decimal;
        TotAvaliable: Decimal;
    begin
        //CBR_SS_02042018..>>
        TotalILEQty := 0;
        ReserveQty := 0;
        CurrLotNo := '';
        TotalILEQty := 0;
        TotAvaliable := 0;
        ItemRec.Get(SalesLine."No.");


        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        if ItemLedgerEntry.FindSet then begin
            ItemLedgerEntry.CalcSums("Remaining Quantity");
            TotalILEQty := ItemLedgerEntry."Remaining Quantity";
        end;

        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", SalesLine."No.");
        ReservEntry.SetRange("Location Code", SalesLine."Location Code");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        if ReservEntry.FindSet then
            repeat
                ReserveQty += ReservEntry."Quantity (Base)";
            until ReservEntry.Next = 0;

        TotAvaliable := TotalILEQty + ReserveQty;

        if SalesLine."Qty. to Ship (Base)" > TotAvaliable then begin
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetCurrentKey("Expiration Date");
            ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
            ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
            if ItemLedgerEntry.FindSet then
                repeat
                    AvablLotQty := 0;
                    LotQty := 0;
                    ILERemainingQty := 0;
                    if CurrLotNo <> ItemLedgerEntry."Lot No." then begin  // Only trigger once for each Lot from the ILE
                        ILE1.Reset;
                        ILE1.SetCurrentKey(ILE1."Expiration Date");
                        ILE1.SetRange("Item No.", SalesLine."No.");
                        ILE1.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                        ILE1.SetFilter("Remaining Quantity", '>%1', 0);
                        if ILE1.FindFirst then begin
                            ILE1.CalcSums("Remaining Quantity");
                            LotQty := GetReservationQty(SalesLine, ILE1);
                            AvablLotQty := ILE1."Remaining Quantity" + LotQty;  // Get the total avaliable quantity
                            if SalesLine."Unit of Measure Code" <> ItemRec."Base Unit of Measure" then   // Check if the item is sold in different UOM
                                CasePackQty += (AvablLotQty div SalesLine."Qty. per Unit of Measure")
                            else
                                CasePackQty += AvablLotQty;
                        end;
                    end;
                    CurrLotNo := ItemLedgerEntry."Lot No.";
                until (ItemLedgerEntry.Next = 0);

            SalesLine.Validate("Qty. to Ship", CasePackQty);
            SalesLine.Modify;
            exit(true);
        end;


        //MESSAGE('Avaliable case pack %1 and  base avaliable qty %2',FORMAT(CasePackQty) ,FORMAT(CasePackQty*SalesLine."Qty. per Unit of Measure"))
        //CBR_SS_02042018..<<
    end;

    local procedure AutoFillTrackingLines(SalesLine: Record "Sales Line"; var ErrorTable: Record "Error Message" temporary): Boolean
    var
        AvablLotQty: Decimal;
        ReservEntry: Record "Reservation Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ILE1: Record "Item Ledger Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LotQty: Decimal;
        TotalILEQty: Decimal;
        RequiredSaleLineQty: Decimal;
        ReserveQty: Decimal;
        SalesLineRec: Record "Sales Line";
        QtytoAssign: Decimal;
        CasePackQty: Decimal;
        ItemRec: Record Item;
        CurrLotNo: Code[20];
        ILERemainingQty: Decimal;
    begin
        //CBR_SS_02042018..>>
        TotalILEQty := 0;
        ReserveQty := 0;

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        if ItemLedgerEntry.FindSet then begin
            ItemLedgerEntry.CalcSums("Remaining Quantity");
            TotalILEQty := ItemLedgerEntry."Remaining Quantity";
        end;

        ReservEntry.Reset;
        ReservEntry.SetRange("Item No.", SalesLine."No.");
        ReservEntry.SetRange("Location Code", SalesLine."Location Code");
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        if ReservEntry.FindSet then
            repeat
                ReserveQty += ReservEntry."Quantity (Base)";
            until ReservEntry.Next = 0;

        // IF (TotalILEQty + ReserveQty) < SalesLine."Qty. to Ship (Base)" THEN
        // BEGIN
        //  InsertErrorLog(SalesLine,(TotalILEQty+ReserveQty),ErrorTable);
        //  EXIT;
        // END;
        CurrLotNo := '';
        RequiredSaleLineQty := SalesLine."Qty. to Ship (Base)";

        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentKey("Expiration Date");
        ItemLedgerEntry.SetRange("Item No.", SalesLine."No.");
        ItemLedgerEntry.SetFilter("Remaining Quantity", '>%1', 0);
        if ItemLedgerEntry.FindSet then
            repeat

                AvablLotQty := 0;
                LotQty := 0;
                ILERemainingQty := 0;

                if CurrLotNo <> ItemLedgerEntry."Lot No." then begin  // Only trigger once for each Lot from the ILE
                    ILE1.Reset;
                    ILE1.SetCurrentKey(ILE1."Expiration Date");
                    ILE1.SetRange("Item No.", SalesLine."No.");
                    ILE1.SetRange("Lot No.", ItemLedgerEntry."Lot No.");
                    ILE1.SetFilter("Remaining Quantity", '>%1', 0);
                    if ILE1.FindFirst then begin
                        ILE1.CalcSums("Remaining Quantity");
                        LotQty := GetReservationQty(SalesLine, ILE1);
                        AvablLotQty := ILE1."Remaining Quantity" + LotQty;  // Get the total avaliable quantity
                        ItemRec.Get(ILE1."Item No.");
                        if SalesLine."Unit of Measure Code" <> ItemRec."Base Unit of Measure" then begin  // Check if the item is sold in different UOM
                            CasePackQty := (AvablLotQty div SalesLine."Qty. per Unit of Measure");
                            AvablLotQty := (CasePackQty * SalesLine."Qty. per Unit of Measure");
                        end;

                        if RequiredSaleLineQty > AvablLotQty then begin
                            QtytoAssign := AvablLotQty;
                            CreateReservEntry.CreateReservEntryFor(DATABASE::"Sales Line", "Document Type", SalesLine."Document No.", '', 0, SalesLine."Line No.", SalesLine."Qty. per Unit of Measure", QtytoAssign, QtytoAssign, '', ILE1."Lot No.");
                            CreateReservEntry.CreateEntry(SalesLine."No.", ILE1."Variant Code", SalesLine."Location Code", SalesLine.Description, SalesLine."Requested Delivery Date", SalesLine."Shipment Date", 0, ReservEntry."Reservation Status"::Surplus);
                        end;
                        if RequiredSaleLineQty <= AvablLotQty then begin
                            QtytoAssign := RequiredSaleLineQty;
                            CreateReservEntry.CreateReservEntryFor(DATABASE::"Sales Line", "Document Type", SalesLine."Document No.", '', 0, SalesLine."Line No.", SalesLine."Qty. per Unit of Measure", QtytoAssign, QtytoAssign, '', ILE1."Lot No.");
                            CreateReservEntry.CreateEntry(SalesLine."No.", ILE1."Variant Code", SalesLine."Location Code", SalesLine.Description, SalesLine."Requested Delivery Date", SalesLine."Shipment Date", 0, ReservEntry."Reservation Status"::Surplus);
                            exit;
                        end;

                        //Reduce the required qty after the previous allocation ++
                        if RequiredSaleLineQty > AvablLotQty then
                            RequiredSaleLineQty := RequiredSaleLineQty - AvablLotQty
                        else
                            RequiredSaleLineQty := AvablLotQty;
                    end;
                end;
                CurrLotNo := ItemLedgerEntry."Lot No.";
            until ItemLedgerEntry.Next = 0;

        if RequiredSaleLineQty <> 0 then
            InsertErrorLog(SalesLine, RequiredSaleLineQty, ErrorTable);
        //CBR_SS_02042018..<<
    end;

    local procedure InsertErrorLog(LocSalesLine: Record "Sales Line"; TotalQuantity: Integer; var ErrorTable: Record "Error Message" temporary)
    begin
        ErrorTable.Init;
        if ErrorTable.FindLast then
            ErrorTable.ID := ErrorTable.ID + 1
        else
            ErrorTable.ID += 1;
        ErrorTable."Record ID" := LocSalesLine.RecordId; //RecRef.RECORDID;
        ErrorTable."Field Number" := LocSalesLine.FieldNo(LocSalesLine."Qty. to Ship (Base)");
        ErrorTable."Message Type" := ErrorTable."Message Type"::Information;
        ErrorTable.Description := 'Enough Lot Quantity is not available to fully assign the Sales Line Quantity ' + Format(LocSalesLine."Qty. to Ship (Base)") + ' for Item ' + LocSalesLine."No." + ' , Balance Lot Quantity is ' + Format(Abs(TotalQuantity));
        ErrorTable."Table Number" := DATABASE::"Sales Line";
        ErrorTable."Field Name" := LocSalesLine.FieldName("Qty. to Ship (Base)");
        ErrorTable."Table Name" := LocSalesLine.TableName;
        ErrorTable.Insert;
    end;

    procedure DeleteReservationEntry(SalesHead: Record "Sales Header")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        //CBR_SS_02042018..>>
        ReservEntry.Reset;
        ReservEntry.SetRange("Source Type", DATABASE::"Sales Line");
        ReservEntry.SetRange("Source ID", SalesHead."No.");
        if ReservEntry.FindSet then
            ReservEntry.DeleteAll;
        //CBR_SS_02042018..<<
    end;
}