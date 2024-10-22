page 50147 "Image Server Setup"
{
    Caption = 'Image Server Setup', Comment = 'DAN="Billedserver setup"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Image Server Setup";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("POST URL"; Rec."POST URL")
                {
                    ToolTip = 'Specifies where to post images to.', Comment = 'DAN="Bestemmer hvor billeder bliver sendt til."';
                }
                field("GET URL"; Rec."GET URL")
                {
                    ToolTip = 'Specifies where to get images from.', Comment = 'DAN="Bestemmer hvor billeder bliver hentet fra."';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();

        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}