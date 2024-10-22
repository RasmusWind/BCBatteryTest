page 50140 "Image Link List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Image Link";
    CardPageId = 50141;
    AdditionalSearchTerms = 'Image, link';

    layout
    {
        area(Content)
        {
            repeater(ContentList)
            {
                field("Related Table ID"; Rec."Related Table ID") { ApplicationArea = All; }
                field("Related Record ID"; Rec."Related Record ID") { ApplicationArea = All; }
                field("Image Link"; Rec."Image Link") { ApplicationArea = All; }
                field("Thumbnail Link"; Rec."Thumbnail Link") { ApplicationArea = All; }
            }
        }
    }
}