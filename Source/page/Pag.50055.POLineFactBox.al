page 50055 "PO Line FactBox"
{
    // version CBR_SS

    PageType = ListPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Quantity; Quantity)
                {
                }
            }
        }
    }

    actions
    {
    }
}

