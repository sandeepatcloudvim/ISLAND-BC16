pageextension 50016 ExtendPurchaseOrderList extends "Purchase Order List"
{
    layout
    {
        addbefore(IncomingDocAttachFactBox)
        {
            part("PO Line FactBox"; "PO Line FactBox")
            {
                ApplicationArea = ALL;
                SubPageLink = "Document Type" = FILTER(Order),
                              "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addafter("Co&mments")
        {
            action("PO Lines not Invoiced")
            {
                Image = OpportunityList;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "PO Lines not Invoiced";
            }
        }
    }

    var
        myInt: Integer;
}