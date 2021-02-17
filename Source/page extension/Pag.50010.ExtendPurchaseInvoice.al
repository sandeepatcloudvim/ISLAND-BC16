pageextension 50010 ExtendPurchaseInvoice extends "Purchase Invoice"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = false;
            ApplicationArea = All;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}