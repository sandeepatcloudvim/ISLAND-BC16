pageextension 50011 ExtendPurchaseCrMemo extends "Purchase Credit Memo"
{
    layout
    {
        modify("Posting Date")
        {
            Visible = false;
            ApplicationArea = All;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}