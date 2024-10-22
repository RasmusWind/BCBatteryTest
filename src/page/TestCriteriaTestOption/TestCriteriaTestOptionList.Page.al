page 50109 "Test Criteria Test Option List"
{
    PageType = List;
    SourceTable = "Test Criteria Test Option";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; NotBlank = true; }
                field("Criteria Name"; Rec."Field Name") { ApplicationArea = All; }
                field(Operation;Rec.Operation) { ApplicationArea = All; }
                field("Test Option"; Rec."Test Option") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("NewTestCriteriaTestOption")
            {
                ApplicationArea = All;
                Caption = 'New Option';
                Image = New;
                trigger OnAction()
                begin
                    Page.RunModal(Page::"Test Criteria Test Option Card");
                end;
            }
        }
    }
}