pageextension 50004 ExtendVendorList extends "Vendor List"
{
    layout
    {
        addafter("Application Method")
        {
            field("Tax Area Code"; "Tax Area Code")
            {
                ApplicationArea = All;
            }
        }
        addbefore(VendorDetailsFactBox)
        {
            part(ItemIncomingAttachments; "Item Incoming Attachments")
            {
                SubPageLink = "Document No." = FIELD("No.");
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