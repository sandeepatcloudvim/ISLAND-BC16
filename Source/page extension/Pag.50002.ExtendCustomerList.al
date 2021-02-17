pageextension 50002 ExtendCustomerList extends "Customer List"
{
    layout
    {
        addbefore(SalesHistSelltoFactBox)
        {
            part(ItemIncomingAttachments; "Item Incoming Attachments")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addbefore("Entry Statistics")
        {
            action("Item Sales History")
            {
                Caption = 'Item Sales History';
                Image = History;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Sales History";
                RunPageLink = "Customer No" = FIELD("No.");
            }
        }
    }

    var
        myInt: Integer;
}