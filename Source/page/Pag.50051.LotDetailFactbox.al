page 50051 "Lot Detail Factbox"
{
    // version CBR_SS

    // CBR_SS_ : 30/03/2018 : Created New Page to show lot detaisl in Factbox

    PageType = CardPart;
    SourceTable = "Value Entry";
    SourceTableView = WHERE("Invoiced Quantity" = FILTER(<> 0));

    layout
    {
        area(content)
        {
            repeater("Lot Details")
            {
                field("Lot No."; ILE."Lot No.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTipML = ENU = 'Specifies a lot number if the posted item carries such a number.',
                                ESM = 'Especifica un número de lote si el producto registrado incluye un número.',
                                FRC = 'Spécifie un numéro de lot si l''article reporté en porte un.',
                                ENC = 'Specifies a lot number if the posted item carries such a number.';
                    trigger OnDrillDown()
                    begin
                        ILE.SETRANGE("Entry No.", "Item Ledger Entry No.");
                        ILE.SETFILTER("Lot No.", '<>%1', '');
                        PAGE.RUNMODAL(6511, ILE);
                    end;

                }
                field(Quantity; -1 * ILE.Quantity)
                {
                    ApplicationArea = ItemTracking;
                    ToolTipML = ENU = 'Specifies a serial number if the posted item carries such a number.',
                                ESM = 'Especifica un número de serie si el producto registrado incluye un número.',
                                FRC = 'Spécifie un numéro de série si l''article reporté en porte un.',
                                ENC = 'Specifies a serial number if the posted item carries such a number.';
                }
                field("Expiration Date"; ILE."Expiration Date")
                {
                    ApplicationArea = ItemTracking;
                    Caption = 'Exp. Date';
                    ToolTipML = ENU = 'Specifies the last date that the item on the line can be used.',
                                ESM = 'Especifica la fecha límite en la que se puede utilizar el producto de la línea.',
                                FRC = 'Spécifie la dernière date à laquelle l''article de la ligne peut être utilisé.',
                                ENC = 'Specifies the last date that the item on the line can be used.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        //ILE.GET("Item Ledger Entry No.");
        ILE.SETRANGE("Entry No.", "Item Ledger Entry No.");
        ILE.SETFILTER("Lot No.", '<>%1', '');
        if ILE.FINDFIRST then;
    end;

    var
        ILE: Record "Item Ledger Entry";
}

