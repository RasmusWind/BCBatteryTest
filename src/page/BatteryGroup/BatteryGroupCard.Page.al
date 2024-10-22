page 50120 "Battery Group Card"
{
    PageType = Card;
    RefreshOnActivate = true;
    Caption = 'Battery Group';
    SourceTable = "Battery Group";

    layout
    {
        area(content)
        {
            group("Group data")
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(BatteryGroupSetup; Rec.BatteryGroupSetup) { ApplicationArea = All; }
            }
            group("Batteries")
            {
                part("Battery List"; "Battery List Part")
                {
                    Editable = false;
                    Caption = 'Battery List';
                    ApplicationArea = All;
                    SubPageLink = Group = FIELD(Code);
                }
            }
        }
    }
}