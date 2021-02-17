pageextension 50013 ExtendAssemblyOrders extends "Assembly Orders"
{
    layout
    {
        addafter("No.")
        {
            field(Status; Status)
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