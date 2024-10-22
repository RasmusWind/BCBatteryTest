page 50110 "Test Criteria Test Option Card"
{
    PageType = Card;
    SourceTable = "Test Criteria Test Option";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(Code; Rec.Code) { ApplicationArea = All; NotBlank = true; }
                field("Criteria Name"; Rec."Field Name") { ApplicationArea = All; }
                field(Operation; Rec.Operation) { ApplicationArea = All; }

                field("Test Option"; Rec."Test Option") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
            }
        }
    }
}