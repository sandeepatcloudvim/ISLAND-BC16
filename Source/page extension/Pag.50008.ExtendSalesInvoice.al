pageextension 50008 ExtendSalesInvoice extends "Sales Invoice"
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