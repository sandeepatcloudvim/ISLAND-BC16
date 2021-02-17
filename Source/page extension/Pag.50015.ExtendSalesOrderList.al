pageextension 50015 ExtendSalesOrderList extends "Sales Order List"
{
    layout
    {
        addbefore(IncomingDocAttachFactBox)
        {
            part("SO Line FactBox"; "SO Line FactBox")
            {
                ApplicationArea = ALL;
                SubPageLink = "Document Type" = FILTER(Order),
                              "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        addafter("Pick Instruction")
        {
            action("Prepare B/L")
            {
                ApplicationArea = Manufacturing;
                Caption = 'Prepare B/L';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Prepare to registers actual item quantities or time used in connection with the sales order. For example, the document can be used by staff who perform any kind of processing work in connection with the sales order. It can also be exported to Excel if you need to process the sales line data further.';

                trigger OnAction()
                begin
                    //CBR_SS_12/19/2019..>>
                    CurrPage.SetSelectionFilter(Rec);
                    REPORT.Run(50003, true, false, Rec);
                    Reset;
                    //CBR_SS_12/19/2019..<<
                end;
            }
        }
    }


    var
        myInt: Integer;
}