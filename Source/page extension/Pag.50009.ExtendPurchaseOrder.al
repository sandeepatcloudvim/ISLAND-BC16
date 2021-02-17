pageextension 50009 ExtendPurchaseOrder extends "Purchase Order"
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