page 50052 "Management Dashboard"
{
    // version CBR_SS

    // CBR_SS : 28032018 : New Page Created

    Caption = 'Management Dashboard';

    layout
    {
        area(content)
        {
            group("Accounts Receivable")
            {
                Caption = 'Accounts Receivable';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Rows;
                grid(Control1000000009)
                {
                    GridLayout = Rows;
                    group(Control1000000012)
                    {
                        field("0 to 30 Days"; Amt30D[1])
                        {
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;
                            StyleExpr = TRUE;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Customer('30D');
                            end;
                        }
                        field("31 to 60 Days"; Amt60D[1])
                        {
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Customer('60D');
                            end;
                        }
                        field("61 to 90 Days"; Amt90D[1])
                        {
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Customer('90D');
                            end;
                        }
                        field("Over 90 Days"; AmtMoreThan90D[1])
                        {
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Customer('MoreThan90D');
                            end;
                        }
                        field("Total "; Amt30D[1] + Amt60D[1] + Amt90D[1] + AmtMoreThan90D[1])
                        {
                            Caption = 'Total';
                            DrillDown = true;
                            MultiLine = true;
                        }
                    }
                }
            }
            group("Account Payable")
            {
                Caption = 'Accounts Payable';
                grid(Control1000000015)
                {
                    GridLayout = Rows;
                    group(Control1000000013)
                    {
                        field("0 to 30 Day"; Amt30D[2])
                        {
                            Caption = '0 to 30 Days';
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;
                            StyleExpr = True;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Vendor('30D');
                            end;
                        }
                        field("31 to 60 Day"; Amt60D[2])
                        {
                            Caption = '31 to 60 Days';
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Vendor('60D');
                            end;
                        }
                        field("61 to 90 Day"; Amt90D[2])
                        {
                            Caption = '61 to 90 Days';
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Vendor('90D');
                            end;
                        }
                        field("Over 90 Day"; AmtMoreThan90D[2])
                        {
                            Caption = 'Over 90 Days';
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;

                            trigger OnDrillDown();
                            begin
                                OpenOverdueInvoicePage_Vendor('MoreThan90D');
                            end;
                        }
                        field("Total. "; Amt30D[2] + Amt60D[2] + Amt90D[2] + AmtMoreThan90D[2])
                        {
                            Caption = 'Total';
                            DrillDown = true;
                            MultiLine = true;
                        }
                    }
                }
            }
            group(Inventory)
            {
                grid(Control1000000016)
                {
                    GridLayout = Rows;
                    group(Control1000000017)
                    {
                        field("Total Inventory"; TotalInv)
                        {
                            Caption = 'Total Inventory Qty';
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;
                            Visible = true;

                            // trigger OnLookup(Text: Text): Boolean;
                            // begin
                            //     PAGE.RUNMODAL(38);
                            // end;

                        }
                        field("Total Inventory Cost"; TotalInvCost)
                        {
                            Caption = 'Total Inventory Value';
                            DrillDown = true;
                            Editable = false;
                            MultiLine = true;

                            // trigger OnLookup(Text: Text): Boolean;
                            // begin
                            //     PAGE.RUNMODAL(5802);
                            // end;
                        }
                    }
                }
            }
            part(Control1000000008; "Bank Account List")
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        CalculateInvDueAmount;
        CalculateInventoryAndCost;
    end;

    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DateVar: array[5] of Date;
        Startdate: Date;
        Enddate: Date;
        NotDue: Text;
        Amt30D: array[2] of Decimal;
        Amt60D: array[2] of Decimal;
        Amt90D: array[2] of Decimal;
        AmtMoreThan90D: array[2] of Decimal;
        CLE: Record "Cust. Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        ValueEntry: Record "Value Entry";
        TotalInvCost: Decimal;
        TotalInv: Decimal;
        RecItem: Record Item;
        ILE: Record "Item Ledger Entry";
        TotAmt: Decimal;

    local procedure CalculateInvDueAmount();
    begin
        Startdate := TODAY;
        Enddate := DMY2DATE(31, 12, 9999);

        //Account Receivable.........>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Amt30D[1] := 0;
        Amt60D[1] := 0;
        Amt90D[1] := 0;
        AmtMoreThan90D[1] := 0;

        DateVar[2] := 0D;
        DateVar[2] := CALCDATE('<-30D>', Startdate);
        CLE.RESET;
        CLE.SETCURRENTKEY("Document Type", "Due Date");
        CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
        CLE.SETRANGE("Due Date", DateVar[2], Startdate - 1);
        if CLE.FINDSET then begin
            repeat
                CLE.CALCFIELDS(Amount);
                Amt30D[1] := Amt30D[1] + CLE.Amount
            until CLE.NEXT = 0;
        end;

        //30 to 60 days
        DateVar[3] := 0D;
        DateVar[3] := CALCDATE('<-60D>', Startdate);
        CLE.RESET;
        CLE.SETCURRENTKEY("Document Type", "Due Date");
        CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
        CLE.SETRANGE("Due Date", DateVar[3], DateVar[2] - 1);
        if CLE.FINDSET then begin

            repeat
                CLE.CALCFIELDS(Amount);
                Amt60D[1] := Amt60D[1] + CLE.Amount
            until CLE.NEXT = 0;
        end;

        // 60 to 90 days
        DateVar[4] := 0D;
        DateVar[4] := CALCDATE('<-90D>', Startdate);
        CLE.RESET;
        CLE.SETCURRENTKEY("Document Type", "Due Date");
        CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
        CLE.SETRANGE("Due Date", DateVar[4], DateVar[3] - 1);
        if CLE.FINDSET then begin

            repeat
                CLE.CALCFIELDS(Amount);
                Amt90D[1] := Amt90D[1] + CLE.Amount
            until CLE.NEXT = 0;
        end;

        //
        // Over 90 days
        DateVar[5] := 0D;
        DateVar[5] := CALCDATE('<-90D>', Startdate);

        CLE.RESET;
        CLE.SETCURRENTKEY("Document Type", "Due Date");
        CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
        CLE.SETFILTER("Due Date", '..%1', DateVar[5]);
        if CLE.FINDSET then begin
            repeat
                CLE.CALCFIELDS(Amount);
                AmtMoreThan90D[1] := AmtMoreThan90D[1] + CLE.Amount
            until CLE.NEXT = 0;
        end;

        CLE.RESET;
        CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
        if CLE.FINDSET then begin
            repeat
                CLE.CALCFIELDS(Amount);
                TotAmt := TotAmt + CLE.Amount
            until CLE.NEXT = 0;
        end;
        //Account Receivable.....................................<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

        //Account Payable.......................................>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        Amt30D[2] := 0;
        Amt60D[2] := 0;
        Amt90D[2] := 0;
        AmtMoreThan90D[2] := 0;

        DateVar[2] := 0D;
        DateVar[2] := CALCDATE('<-30D>', Startdate);
        VLE.RESET;
        VLE.SETCURRENTKEY("Document Type", "Due Date");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        VLE.SETRANGE("Due Date", DateVar[2], Startdate - 1);

        if VLE.FINDSET then begin
            repeat
                VLE.CALCFIELDS(Amount);
                Amt30D[2] := Amt30D[2] + VLE.Amount;
            until VLE.NEXT = 0;
        end;

        //30 to 60 days
        DateVar[3] := 0D;
        DateVar[3] := CALCDATE('<-60D>', Startdate);
        VLE.RESET;
        VLE.SETCURRENTKEY("Document Type", "Due Date");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        VLE.SETRANGE("Due Date", DateVar[3], DateVar[2] - 1);
        if VLE.FINDSET then begin

            repeat
                VLE.CALCFIELDS(Amount);
                Amt60D[2] := Amt60D[2] + VLE.Amount
            until VLE.NEXT = 0;
        end;

        // 60 to 90 days
        DateVar[4] := 0D;
        DateVar[4] := CALCDATE('<-90D>', Startdate);
        VLE.RESET;
        VLE.SETCURRENTKEY("Document Type", "Due Date");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        VLE.SETRANGE("Due Date", DateVar[4], DateVar[3] - 1);
        if VLE.FINDSET then begin

            repeat
                VLE.CALCFIELDS(Amount);
                Amt90D[2] := Amt90D[2] + VLE.Amount
            until VLE.NEXT = 0;
        end;

        //
        // Over 90 days
        DateVar[5] := 0D;
        DateVar[5] := CALCDATE('<-90D>', Startdate);

        VLE.RESET;
        VLE.SETCURRENTKEY("Document Type", "Due Date");
        VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
        VLE.SETFILTER("Due Date", '..%1', DateVar[5]);
        if VLE.FINDSET then begin
            repeat
                VLE.CALCFIELDS(Amount);
                AmtMoreThan90D[2] := AmtMoreThan90D[2] + VLE.Amount
            until VLE.NEXT = 0;
        end;
        //Account Payable.......................................<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    end;

    local procedure OpenOverdueInvoicePage_Customer(Days: Text);
    var
        OverDueInvoices: Page "Customer Ledger Entries";
    begin
        Startdate := TODAY;
        Enddate := DMY2DATE(31, 12, 9999);

        //Account Receivable....................................>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        case Days of
            '30D':
                begin
                    //DateVar[2] :=0D;
                    DateVar[2] := CALCDATE('<-30D>', Startdate);
                    CLE.RESET;
                    CLE.SETRANGE("Due Date", DateVar[2], Startdate - 1);
                    CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
                    if CLE.FINDSET then;
                end;
            '60D':
                begin
                    //DateVar[3] :=0D;
                    DateVar[3] := CALCDATE('<-60D>', Startdate);
                    CLE.RESET;
                    CLE.SETRANGE("Due Date", DateVar[3], DateVar[2] - 1);
                    CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
                    if CLE.FINDSET then;
                end;
            '90D':
                begin
                    // DateVar[4] :=0D;
                    DateVar[4] := CALCDATE('<-90D>', Startdate);
                    CLE.RESET;
                    CLE.SETRANGE("Due Date", DateVar[4], DateVar[3] - 1);
                    CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
                    if CLE.FINDSET then;
                end;
            'MoreThan90D':
                begin
                    // DateVar[5] :=0D;
                    DateVar[5] := CALCDATE('<-90D>', Startdate);

                    CLE.RESET;
                    CLE.SETFILTER("Due Date", '..%1', DateVar[5]);
                    CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
                    if CLE.FINDSET then;
                end;
            'AllSalesInv':
                begin
                    // DateVar[5] :=0D;

                    CLE.RESET;
                    CLE.SETRANGE("Document Type", CLE."Document Type"::Invoice);
                    if CLE.FINDSET then;
                end;

        end;
        PAGE.RUNMODAL(25, CLE);
        //Account Receivable....................................<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    end;

    local procedure OpenOverdueInvoicePage_Vendor(Days: Text);
    var
        OverDueInvoices: Page "Vendor Ledger Entries";
    begin
        Startdate := TODAY;
        Enddate := DMY2DATE(31, 12, 9999);

        //Account Payable....................................>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        case Days of
            '30D':
                begin
                    DateVar[2] := 0D;
                    DateVar[2] := CALCDATE('<-30D>', Startdate);
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document Type", "Due Date");
                    VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                    VLE.SETRANGE("Due Date", DateVar[2], Startdate - 1);
                    if VLE.FINDSET then;
                end;
            '60D':
                begin
                    DateVar[3] := 0D;
                    DateVar[3] := CALCDATE('<-60D>', Startdate);
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document Type", "Due Date");
                    VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                    VLE.SETRANGE("Due Date", DateVar[3], DateVar[2] - 1);
                    if VLE.FINDSET then;
                end;
            '90D':
                begin
                    DateVar[4] := 0D;
                    DateVar[4] := CALCDATE('<-90D>', Startdate);
                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document Type", "Due Date");
                    VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                    VLE.SETRANGE("Due Date", DateVar[4], DateVar[3] - 1);
                    if VLE.FINDSET then;
                end;
            'MoreThan90D':
                begin
                    DateVar[5] := 0D;
                    DateVar[5] := CALCDATE('<-90D>', Startdate);

                    VLE.RESET;
                    VLE.SETCURRENTKEY("Document Type", "Due Date");
                    VLE.SETRANGE("Document Type", VLE."Document Type"::Invoice);
                    VLE.SETFILTER("Due Date", '..%1', DateVar[5]);
                    if VLE.FINDSET then;
                end;
        end;
        PAGE.RUNMODAL(29, VLE);
        //Account Payable....................................<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    end;

    local procedure CalculateInventoryAndCost();
    begin
        TotalInvCost := 0;
        TotalInv := 0;
        // ValueEntry.RESET;
        // IF ValueEntry.FINDSET THEN
        // REPEAT
        //  TotalInvCost := TotalInvCost + ValueEntry."Cost Amount (Actual)";
        // UNTIL  ValueEntry.NEXT =0;
        ILE.RESET;
        if ILE.FIND('-') then
            repeat
                ILE.CALCFIELDS("Cost Amount (Actual)");
                TotalInvCost := TotalInvCost + ILE."Cost Amount (Actual)";
            until ILE.NEXT = 0;

        RecItem.RESET;
        if RecItem.FINDSET then
            repeat
                RecItem.CALCFIELDS(Inventory);
                TotalInv := TotalInv + RecItem.Inventory;
            until RecItem.NEXT = 0;
    end;
}

