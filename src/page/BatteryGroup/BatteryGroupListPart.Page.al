page 50122 "Battery Group List Part"
{
    PageType = ListPart;
    SourceTable = "Battery Group";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Batteries; Batteries) { ApplicationArea = All; }
            }
        }
    }

    var
        Batteries: Text;

    trigger OnAfterGetCurrRecord()
    var
        Text: Text;
        Battery: Record Battery;
        Iteration: Integer;
    begin
        Battery.SetRange(Group, Rec.Code);
        Iteration := 0;
        if Battery.FindFirst() then begin
            repeat
                if Iteration = 0 then
                    Text := Battery.ItemLedgerEntry
                else
                    Text := Text + ', ' + Battery.ItemLedgerEntry;

                Iteration += 1;
            until Battery.Next() = 0;
        end;

        Batteries := Text;
    end;
}