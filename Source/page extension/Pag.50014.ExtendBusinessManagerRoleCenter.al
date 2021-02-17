pageextension 50014 ExtendBusinessManager extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Chart of Accounts")
        {
            action("Payment Journals")
            {
                Caption = 'Payment Journals';
                RunObject = Page "General Journal Batches";
                RunPageView = SORTING("Journal Template Name", Name)
                              WHERE("Journal Template Name" = FILTER('PAYMENTS'));
            }
        }
        addafter(CashReceiptJournals)
        {
            action(PaymentJournals1)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "General Journal Batches";
                RunPageView = WHERE("Template Type" = CONST(Payments),
                                        Recurring = CONST(false));
                ToolTip = 'Register payments to vendors. A payment journal is a type of general journal that is used to post outgoing payment transactions to G/L, bank, customer, vendor, employee, and fixed assets accounts. The Suggest Vendor Payments functions automatically fills the journal with payments that are due. When payments are posted, you can export the payments to a bank file for upload to your bank if your system is set up for electronic banking. You can also issue computer checks from the payment journal.';
            }
        }
    }

    var
        myInt: Integer;
}