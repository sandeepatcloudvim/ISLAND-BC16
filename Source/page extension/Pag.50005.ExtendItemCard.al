pageextension 50005 ExtendItemCard extends "Item Card"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                Caption = 'Description 2';
            }
        }
        addafter("Base Unit of Measure")
        {
            field(MasterUPC; MasterUPC)
            {
                Caption = 'Master Case UPC';
                ApplicationArea = All;
            }
            field(CaseUPC; CaseUPC)
            {
                Caption = 'Sleeve UPC';
                ApplicationArea = All;
            }
            field(EachUPC; EachUPC)
            {
                Caption = 'Unit UPC';
                ApplicationArea = All;
            }
            field("UPC Search Code"; "UPC Search Code")
            {
                Caption = 'UPC Search Code';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addbefore(Approval)
        {
            group(CBRIncomingDocument)
            {
                Caption = 'Item Documents';
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
                        IncomingDocument.ShowCardCBR("No.");                        //CBR_SS_29052018
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
            HasIncomingDocument := true
        else
            HasIncomingDocument := false
        //CBR_SS_22/02/2018..<<
    end;
}