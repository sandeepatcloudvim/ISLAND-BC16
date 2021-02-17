pageextension 50000 ExtendChartofAccounts extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addbefore("General Journal")
        {
            action("Management DashBoard")
            {
                Caption = 'Management DashBoard';
                Image = Register;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                RunObject = Page "Management Dashboard";
            }
        }
    }

    var
        myInt: Integer;
}