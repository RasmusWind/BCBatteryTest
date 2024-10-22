page 50118 "Battery Group Setup List"
{
    SourceTable = "Battery Group Setup";
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = true;
    Caption = 'Battery Group Setup';
    AdditionalSearchTerms = 'batteries, battery, bats, group, grouping';


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; }
                field(Capacity; Rec.Capacity) { ApplicationArea = All; }

            }
        }
    }
}