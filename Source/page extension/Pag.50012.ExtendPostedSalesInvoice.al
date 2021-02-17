pageextension 50012 ExtendPostedSalesInvoice extends "Posted Sales Invoice"
{
    layout
    {
        addafter("Responsibility Center")
        {
            field("PRO#"; "PRO#")
            {
                ApplicationArea = All;
            }
            field("Shipping Window"; "Shipping Window")
            {
                ApplicationArea = All;
            }
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Customer Disc. Group"; "Customer Disc. Group")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}