pageextension 50006 ExtendItemList extends "Item List"
{
    layout
    {
        addafter(Description)
        {
            field("UPC Search Code"; "UPC Search Code")
            {
                Caption = 'UPC Search Code';
                ApplicationArea = All;
            }
            field("Description 2"; "Description 2")
            {
                Caption = 'Description2';
                ApplicationArea = All;
            }
        }
        addafter("Created From Nonstock Item")
        {
            field("Qty. on Purch. Order"; "Qty. on Purch. Order")
            {
                ApplicationArea = All;
            }
            field("Qty. on Sales Order"; "Qty. on Sales Order")
            {
                ApplicationArea = All;
            }
            field("Qty Available"; QtyAvailable)
            {
                ApplicationArea = All;
            }
            field("Qty To Reorder"; QtyToReorder)
            {
                ApplicationArea = All;
            }
        }
        addbefore("Shelf No.")
        {
            field(MasterUPC; MasterUPC)
            {
                Caption = 'Master UPC';
                ApplicationArea = All;
            }
            field(CaseUPC; CaseUPC)
            {
                Caption = 'Sleeve UPC';
                ApplicationArea = All;
            }
            field(EachUPC; EachUPC)
            {
                Caption = 'Unit UPC';
                ApplicationArea = All;
            }
        }
        addbefore("Inventory Posting Group")
        {
            field("Case Pack Qty"; ItemUOM."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Case Qty on Hand"; Inventory / (ItemUOM."Qty. per Unit of Measure"))
            {
                ApplicationArea = All;
            }
            field("Case Unit Price"; "Unit Price" * ItemUOM."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
            }
            field("Case Unit Cost"; "Unit Cost" * ItemUOM."Qty. per Unit of Measure")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Vendor No.")
        {
            field("Manufacturer Code"; "Manufacturer Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Stockkeepin&g Units")
        {
            action("Item Stock Status Info")
            {
                Caption = 'Item Stock Status Info';
                Image = SNInfo;
                RunObject = Page "Item Stock Status Info";
                RunPageLink = "Item No." = FIELD("No.");
            }
        }
    }

    var
        myInt: Integer;
        ItemUOM: Record "Item Unit of Measure";
        QtyAvailable: Decimal;
        QtyToReorder: Decimal;

    trigger OnAfterGetRecord()
    begin

        //CBR_SS_05032018..>>
        if ItemUOM.Get("No.", "Sales Unit of Measure") then;
        CalcFields(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
        QtyAvailable := Inventory + "Qty. on Purch. Order" - "Qty. on Sales Order";
        QtyToReorder := "Reorder Quantity" - QtyAvailable;
        //CBR_SS_05032018..<<
    end;

    trigger OnAfterGetCurrRecord()
    begin
        //CBR_SS_05032018..>>
        CALCFIELDS(Inventory, "Qty. on Purch. Order", "Qty. on Sales Order");
        QtyAvailable := Inventory + "Qty. on Purch. Order" - "Qty. on Sales Order";
        QtyToReorder := "Reorder Quantity" - QtyAvailable;
        //CBR_SS_05032018..<<
    end;
}