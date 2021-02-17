tableextension 50007 ExtendWarehouseEntry extends "Warehouse Entry"
{
    fields
    {
        field(50000; Open; Boolean)
        {
            CalcFormula = Exist ("Item Ledger Entry" WHERE("Item No." = FIELD("Item No."),
                                                           "Location Code" = FIELD("Location Code"),
                                                           "Document No." = FIELD("Reference No."),
                                                           "Lot No." = FIELD("Lot No."),
                                                           Open = FILTER(true)));
            Description = 'CBR_SS';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "Item Description"; Text[50])
        {
            Description = 'CBR_SS';
        }
    }

    var
        myInt: Integer;
}