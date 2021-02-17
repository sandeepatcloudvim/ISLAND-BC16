page 50050 "Item Sales History"
{
    // version CBR_SS

    // CBR_SS_ : 30/03/2018 : Created New Page

    Caption = 'Item Sales History';
    Editable = false;
    PageType = List;
    SourceTable = "Item Sales History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No"; "Invoice No")
                {
                    Importance = Promoted;
                }
                field("Customer No"; "Customer No")
                {
                }
                field("External Document No."; "External Document No.")
                {
                }
                field("Original Sales Order No"; "Original Sales Order No")
                {
                    Importance = Promoted;
                }
                field("Salesperson Code"; "Salesperson Code")
                {
                }
                field("Customer Name"; "Customer Name")
                {
                }
                field("Bill-to Address"; "Bill-to Address")
                {
                }
                field("Line No."; "Line No.")
                {
                }
                field("Bill-to City"; "Bill-to City")
                {
                }
                field("Bill-to State"; "Bill-to State")
                {
                }
                field("Bill-to Zip"; "Bill-to Zip")
                {
                }
                field("Ship-to Address"; "Ship-to Address")
                {
                }
                field("Ship-to Address2"; "Ship-to Address2")
                {
                }
                field("Ship-to City"; "Ship-to City")
                {
                }
                field("Ship-to State"; "Ship-to State")
                {
                }
                field("Ship-to Zip"; "Ship-to Zip")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
                field("Due date"; "Due date")
                {
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                }
                field("Customer Price Group"; "Customer Price Group")
                {
                }
                field("Customer Disc. Group"; "Customer Disc. Group")
                {
                }
                field("Shipping Agent Code"; "Shipping Agent Code")
                {
                }
                field("Shipping Method Code"; "Shipping Method Code")
                {
                }
                field("Package Tracking No."; "Package Tracking No.")
                {
                }
                field("Item No."; "Item No.")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field("Unit of Measure Code"; "Unit of Measure Code")
                {
                }
                field("Qty Invoiced"; "Qty Invoiced")
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Unit Cost (Item)"; "Unit Cost (Item)")
                {
                }
                field("Extended Price"; "Extended Price")
                {
                }
                field("Extended Cost"; "Extended Cost")
                {
                }
                field("Margin Amount"; "Margin Amount")
                {
                }
                field("Location Code"; "Location Code")
                {
                }
                field("Manufacturer Code"; "Manufacturer Code")
                {
                }
                field("Vendor No"; "Vendor No")
                {
                }
                field("Vendor Item No"; "Vendor Item No")
                {
                }
                field("Item Category"; "Item Category")
                {
                }
                field("Cross Reference No"; "Cross Reference No")
                {
                }
                field("Qty. per Unit of Measure"; "Qty. per Unit of Measure")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000005; "Lot Detail Factbox")
            {
                SubPageLink = "Document No." = FIELD("Invoice No"),
                              "Item No." = FIELD("Item No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShoInvoice)
            {
                Caption = 'Show Invoice';
                Image = SalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    DocNo: Code[20];
                begin
                    if SalesInvHead.GET("Invoice No") then
                        PAGE.RUNMODAL(PAGE::"Posted Sales Invoice", SalesInvHead)
                end;
            }
            action(ShowtrackingLine)
            {
                Caption = 'Show Tracking Line';
                Image = TraceOppositeLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    ShowItemTrackingLines;
                end;
            }
            action("Create Lines")
            {
                Caption = 'Refresh Data';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    UpdateItemHistory;
                end;
            }
        }
    }

    var
        SalesInvHead: Record "Sales Invoice Header";
        RecItem: Record Item;
        TotalPrice: Decimal;
}

