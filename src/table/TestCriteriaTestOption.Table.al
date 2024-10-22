table 50109 "Test Criteria Test Option"
{
    Caption = 'Test Criteria Test Field';
    DataPerCompany = true;

    fields
    {
        field(1; Code; Code[20]) { }
        field(2; "Field Name"; Text[50])
        {
            Caption = 'Field Name';
        }
        field(3; List; Boolean)
        {
            ToolTip = 'Use multiple objects if list can be found.';
        }
        field(4; Description; Text[200])
        {
            Caption = 'Description';
        }
        field(5; "Test Option"; Code[20])
        {
            TableRelation = "Test Criteria Test Option";
        }
        field(6; Operation; Option)
        {
            NotBlank = false;
            OptionMembers = " ","count","maximum","minimum","average";
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