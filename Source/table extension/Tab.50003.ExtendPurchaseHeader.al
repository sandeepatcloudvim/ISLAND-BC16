tableextension 50003 ExtendPurchaseHeader extends "Purchase Header"
{
    fields
    {
        modify("Posting Date")
        {
            trigger OnAfterValidate()
            begin
                //CBR_SS++
                IF "Posting Date" <> xRec."Posting Date" THEN
                    "Document Date" := "Posting Date";
                //CBR_SS--
            end;
        }
        modify("Document Date")
        {
            trigger OnAfterValidate()
            begin
                //CBR_SS++
                "Posting Date" := "Document Date";
                //CBR_SS--
            end;
        }
    }

    var
        myInt: Integer;
}