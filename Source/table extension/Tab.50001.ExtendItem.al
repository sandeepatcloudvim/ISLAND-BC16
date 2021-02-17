tableextension 50001 ExtendItem extends Item
{
    fields
    {
        field(50000; "MasterUPC"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "EachUPC"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "CaseUPC"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "UPC Search Code"; Code[5])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(pk; "UPC Search Code")
        {

        }
    }
    var
        myInt: Integer;
}