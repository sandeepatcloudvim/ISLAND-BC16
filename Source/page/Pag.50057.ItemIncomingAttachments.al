page 50057 "Item Incoming Attachments"
{
    // version NAVW110.00,SS_CBR

    CaptionML = ENU = 'Attachments',
                ESM = 'Atributos de producto',
                FRC = 'Attributs article',
                ENC = 'Attachments';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Incoming Document Attachment";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Name; Name)
                {

                    // trigger OnLookup(Text: Text): Boolean;
                    // begin
                    //     IncomingDocument.ShowCardCBR("Document No.");//CAN_SC_22/02/2018..>>
                    // end;
                }
                field(Type; Type)
                {
                }
                field("Posting Date"; "Posting Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        IncomingDocument: Record "Incoming Document";
        DocumentNo: Code[20];

    procedure GetDocumentNo(ItemNo: Code[20]);
    begin
        //DocumentNo:=ItemNo;
        //MESSAGE(DocumentNo)
    end;
}

