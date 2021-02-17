pageextension 50001 ExtendCustomerCard extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
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
        addbefore(Workflow)
        {
            group(CBRIncomingDocument)
            {
                Caption = 'Customer Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View File';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCardCBR("No.");      //CBR_SS_29052018
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Select Incoming Document';
                    Enabled = NOT HasIncomingDocument;
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';
                    Visible = false;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument("No.", WorkDate, RecordId);    //CBR_SS_29052018
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attach File';
                    Ellipsis = true;
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument("No.", WorkDate)            //CBR_SS_29052018
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
        HasIncomingDocument: Boolean;
        IncDoc: Record "Incoming Document";


    trigger OnAfterGetRecord()
    begin
        ForIncomingDoc;//SS_CBR
    end;

    local procedure ForIncomingDoc()
    begin
        //CBR_SS_22/02/2018..>>
        IncDoc.Reset;
        IncDoc.SetRange("Document No.", "No.");
        if IncDoc.FindFirst then
            HasIncomingDocument := true;
        //CBR_SS_22/02/2018..<<
    end;
}