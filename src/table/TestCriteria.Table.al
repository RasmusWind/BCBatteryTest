table 50102 "Test Criteria"
{
    Caption = 'Test Criteria';
    DataPerCompany = true;

    fields
    {
        field(1; Id; Integer)
        {
            AutoIncrement = true;
        }
        field(2; BatteryTest; Code[20])
        {
            TableRelation = "Battery Test";
        }
        field(3; "Test Option"; Code[20])
        {
            Caption = 'Test Option';
            TableRelation = "Test Criteria Test Option";
            Editable = true;
        }
        field(4; Operator; Option)
        {
            OptionMembers = "Equal","Not equal","Less than","Less than or equal","Greater than","Greater than or equal","Range";
        }
        field(5; "Test Value"; Decimal) { }
        field(6; Active; Option)
        {
            OptionMembers = "Yes","No";
            ToolTip = 'Sets the test criteria as active or inactive. Inactive test criterias will be skipped when testing batteries.';
        }
        field(7; "Group Criteria"; Boolean)
        {
            ToolTip = 'If true, the criteria will only be used on groups of batteries. If false, the criteria will be used on every battery.';
        }
        field(8; "Test Option 2"; Code[20])
        {
            Caption = 'Test Criteria';
            TableRelation = "Test Criteria Test Option";
            Editable = true;
        }
        field(9; "Test Value Percent"; Boolean)
        {
            Caption = 'Percent Value';
        }
    }

    keys
    {
        key(PrimaryKey; Id)
        {
            Clustered = true;
        }
    }

}