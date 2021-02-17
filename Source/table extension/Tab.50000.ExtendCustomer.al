tableextension 50000 ExtendCustomer extends Customer
{
    fields
    {
        field(50000; "Shipper AcctNo"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}