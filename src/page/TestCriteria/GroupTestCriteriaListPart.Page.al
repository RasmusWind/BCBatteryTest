page 50106 "Group Test Criteria List Part"
{
    PageType = ListPart;
    SourceTable = "Test Criteria";
    ApplicationArea = All;
    // InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(TestCriteria)
            {
                field("Test Option"; Rec."Test Option")
                {
                    ApplicationArea = All;
                    Caption = 'Test Field';

                    trigger OnAssistEdit()
                    var
                        TCTFList: Page "Test Criteria Test Option List";
                    begin
                        if TCTFList.RunModal() = Action::LookupOK then
                            CurrPage.Update(false);
                    end;
                }
                field(Operator; Rec.Operator)
                {
                    ApplicationArea = All;
                    Caption = 'Operator';
                }
                field("Single Test Option"; Rec."Test Option 2")
                {
                    ApplicationArea = All;
                    Caption = 'Single Test Option';

                    trigger OnAssistEdit()
                    var
                        TCTFList: Page "Test Criteria Test Option List";
                    begin
                        if TCTFList.RunModal() = Action::LookupOK then
                            CurrPage.Update(false);
                    end;
                }
                field("Test Value"; Rec."Test Value")
                {
                    ApplicationArea = All;
                    Caption = 'Test Value';
                }
                field("Test Value Percent"; Rec."Test Value Percent")
                {
                    ApplicationArea = All;
                    Caption = 'Percent Value';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    Caption = 'Active';
                }
                field("Group Criteria"; Rec."Group Criteria")
                {
                    ApplicationArea = All;
                    Caption = 'Group Criteria';
                }
            }
        }
    }

    var
        ParentRec_code: Code[20];

    trigger OnOpenPage()
    begin
        Rec.SetRange("Group Criteria", true);
    end;

    procedure SetParent(record_code: Code[20])
    begin
        ParentRec_code := record_code;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if CurrPage.Editable then begin
            Rec.BatteryTest := ParentRec_code;
            Rec."Group Criteria" := true;
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;
}