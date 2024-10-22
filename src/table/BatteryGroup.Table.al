table 50114 "Battery Group"
{
    Caption = 'Battery Group';
    DataPerCompany = true;

    fields
    {
        field(1; Code; Code[20]) { }
        field(2; BatteryTest; Code[20])
        {
            TableRelation = "Battery Test";
        }
        field(3; BatteryGroupSetup; Code[20])
        {
            NotBlank = true;
            TableRelation = "Battery Group Setup";
        }
        field(4; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    trigger OnDelete()
    var
        Battery: Record Battery;
    begin
        Battery.SetRange(Group, Rec.Code);
        if Battery.FindFirst() then begin
            repeat
                Battery.Group := '';
                Battery.Modify();
            until Battery.Next() = 0;
        end;
    end;
}