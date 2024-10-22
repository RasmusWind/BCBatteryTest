table 50113 "Battery Test Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Battery Test Setup';

    fields
    {
        field(1; Code; Code[10])
        {
            DataClassification = SystemMetadata;
            Caption = 'Primary Key';
            Editable = false;
            InitValue = 'SETUP';
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }

    }

    keys
    {
        key(PrimaryKey; Code)
        {
            Clustered = true;
        }
    }
}