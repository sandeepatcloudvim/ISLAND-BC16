page 50056 "SO Line FactBox"
{
    // version CBR_SS

    PageType = ListPart;
    SourceTable = "Sales Line";

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

