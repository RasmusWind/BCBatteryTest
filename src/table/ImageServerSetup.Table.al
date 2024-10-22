table 50146 "Image Server Setup"
{
    Caption = 'Image server setup', Comment = 'DAN="Billedserver setup"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "POST URL"; Text[100])
        {
            Caption = 'Image POST URL';
        }
        field(3; "GET URL"; Text[100])
        {
            Caption = 'Image GET URL';
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