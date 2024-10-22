page 50119 "Battery Group List"
{
    PageType = List;
    SourceTable = "Battery Group";
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'Battery Groups';
    AdditionalSearchTerms = 'batteries, battery, bats, group, grouping, groups';
    CardPageId = "Battery Group Card";

    layout{
        area(content){
            repeater(Group){
                field(Code;Rec.Code) {ApplicationArea = All;}
                field(BatteryGroupSetup;Rec.BatteryGroupSetup) {ApplicationArea = All;}
                
            }
        }
    }
}