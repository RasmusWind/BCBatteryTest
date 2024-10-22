table 50149 "Image Link"
{

    fields
    {
        field(1; "Primary Key"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Related Table ID"; Integer)
        {
            Caption = 'Related Table ID';
        }
        field(3; "Related Record ID"; Text[100])
        {
            Caption = 'Related Record ID';
        }
        field(4; "Image Link"; Text[100])
        {
            Caption = 'Image Link';
        }
        field(5; "Thumbnail Link"; Text[100])
        {
            Caption = 'Thumbnail Link';
        }
        field(6; "Image Width"; Decimal)
        {
            Caption = 'Image Width';
        }
        field(7; "Image Height"; Decimal)
        {
            Caption = 'Image Height';
        }
        field(8; "Thumbnail Width"; Decimal)
        {
            Caption = 'Thumbnail Width';
        }
        field(9; "Thumbnail Height"; Decimal)
        {
            Caption = 'Thumbnail Height';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}