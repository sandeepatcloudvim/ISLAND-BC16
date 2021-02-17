page 50053 "PO Lines not Invoiced"
{
    // version CBR_SS

    // CBR_SS 070518 - Added Code.

    Editable = false;
    PageType = List;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order),
                            "Qty. Rcd. Not Invoiced" = FILTER(> 0));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("PO No."; "Document No.")
                {
                    CaptionML = ENU = 'PO No.',
                                ESM = 'Nº documento',
                                FRC = 'N° de document',
                                ENC = 'Document No.';
                }
                field("PO Date"; "Order Date")
                {
                    CaptionML = ENU = 'PO Date',
                                ESM = 'Fecha pedido',
                                FRC = 'Date commande',
                                ENC = 'Order Date';
                }
                field("Vendor ID"; "Buy-from Vendor No.")
                {
                    CaptionML = ENU = 'Vendor ID',
                                ESM = 'Compra a-Nº proveedor',
                                FRC = 'N° fournisseur exécutant',
                                ENC = 'Buy-from Vendor No.';
                }
                field("Vendor Name"; VendorName.Name)
                {
                    Caption = 'Vendor Name';
                }
                field(ItemNo; "No.")
                {
                    CaptionML = ENU = 'Item No.',
                                ESM = 'Nº',
                                FRC = 'N°',
                                ENC = 'ItemNo.';
                    Editable = false;
                    HideValue = false;
                }
                field("Item Description"; Description)
                {
                    CaptionML = ENU = 'Item Description',
                                ESM = 'Descripción',
                                FRC = 'Description',
                                ENC = 'Description';
                }
                field("Quantity Order"; Quantity)
                {
                    CaptionML = ENU = 'Quantity Order',
                                ESM = 'Cantidad',
                                FRC = 'Quantité',
                                ENC = 'Quantity';
                }
                field("Qty Received"; "Quantity Received")
                {
                    CaptionML = ENU = 'Qty Received',
                                ESM = 'Cantidad a recibir',
                                FRC = 'Quantité à recevoir',
                                ENC = 'Qty. to Receive';
                }
                field("Qty Invoiced"; "Quantity Invoiced")
                {
                    CaptionML = ENU = 'Qty Invoiced',
                                ESM = 'Cdad. a facturar',
                                FRC = 'Quantité à facturer',
                                ENC = 'Qty. to Invoice';
                }
                field("Unit Amount"; "Unit Cost")
                {
                    CaptionML = ENU = 'Unit Amount',
                                ESM = 'Precio unitario ($)',
                                FRC = 'Prix unitaire ($)',
                                ENC = 'Unit Price ($)';
                }
                field("Original PO Amount"; Amount)
                {
                    CaptionML = ENU = 'Original PO Amount',
                                ESM = 'Importe',
                                FRC = 'Montant',
                                ENC = 'Amount';
                }
                field("Qty. Rcd. Not Invoiced"; "Qty. Rcd. Not Invoiced")
                {
                }
                field("Amt. Rcd. Not Invoiced"; "Amt. Rcd. Not Invoiced")
                {
                    CaptionML = ENU = 'Amt. Rcd. Not Invoiced',
                                ESM = 'Imp. recibido no factur. ($)',
                                FRC = 'Montant reçu non facturé ($)',
                                ENC = 'Amt. Rcd. Not Invoiced ($)';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        if VendorName.GET("Buy-from Vendor No.") then;
    end;

    var
        VendorName: Record Vendor;
        PurchaseHeader: Record "Purchase Header";
}

