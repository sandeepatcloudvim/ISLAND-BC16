tableextension 50002 ExtendSalesHeader extends "Sales Header"
{
    fields
    {
        field(50000; "PRO#"; Text[30])
        {
        }
        field(50001; "Shipping Window"; Text[30])
        {
        }
        field(50002; "Cancellation Date"; Date)
        {
        }
        field(50003; "Created By UserID"; Code[50])
        {
            Description = 'CBR_SS';
            Editable = false;
        }
        field(50004; "Created By User Name"; Text[50])
        {
            Description = 'CBR_SS';
            Editable = false;
        }
        field(50005; "Creation Time"; Time)
        {
            Description = 'CBR_SS';
            Editable = false;
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

    trigger OnAfterInsert()
    begin
        //CBR_SS++
        "Created By UserID" := UserId;
        "Created By User Name" := GetUserName;
        "Creation Time" := Time;
        //CBR_SS--
    end;

    local procedure GetUserName(): Text
    var
        UserRec: Record User;
    begin
        UserRec.Reset;
        UserRec.SetRange("User Name", UserId);
        if UserRec.FindFirst then
            exit(UserRec."Full Name")
    end;
}