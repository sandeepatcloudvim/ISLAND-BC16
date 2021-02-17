tableextension 50004 ExtendSalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50000; "PRO#"; Text[30])
        {
        }
        field(50001; "Shipping Window"; Text[30])
        {
        }
    }

    var
        myInt: Integer;
}