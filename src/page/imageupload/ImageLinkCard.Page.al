page 50141 "Image Link Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Image Link";
    DataCaptionExpression = CustomPageCaption;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Related Table ID"; Rec."Related Table ID") { ApplicationArea = All; Editable = false; }
                field("Related Record ID"; Rec."Related Record ID") { ApplicationArea = All; Editable = false; }
                field("Image Link"; Rec."Image Link") { ApplicationArea = All; Editable = false; }
                field("Thumbnail Link"; Rec."Thumbnail Link") { ApplicationArea = All; Editable = false; }
                field("Thumbnail Width"; Rec."Thumbnail Width") { ApplicationArea = All; Editable = false; }
                field("Thumbnail Height"; Rec."Thumbnail Height") { ApplicationArea = All; Editable = false; }
                field("Image Width"; Rec."Image Width") { ApplicationArea = All; Editable = false; }
                field("Image Height"; Rec."Image Height") { ApplicationArea = All; Editable = false; }
            }
        }
    }

    var
        CustomPageCaption: Text;

    trigger OnOpenPage()
    var
        URLSPLIT: List of [Text];
    begin
        if Rec."Image Link" <> '' then begin
            URLSPLIT := SplitString(Rec."Image Link", '/');
            CustomPageCaption := URLSPLIT.Get(URLSPLIT.Count());
        end;

    end;



    procedure SplitString(InputString: Text; Delimiter: Char): List of [Text]
    var
        StartPos: Integer;
        DelimiterPos: Integer;
        Part: Text;
        Parts: List of [Text];
    begin
        StartPos := 1;

        repeat

            DelimiterPos := STRPOS(InputString, Delimiter);

            if DelimiterPos > 0 then begin
                if DelimiterPos > 1 then begin
                    Part := COPYSTR(InputString, 1, DelimiterPos - 1);
                    Parts.Add(Part);
                end;
                StartPos := DelimiterPos + 1;
                InputString := COPYSTR(InputString, StartPos);
            end else begin
                Part := COPYSTR(InputString, 1);
                Parts.Add(Part);
                StartPos := 0; // Exit the loop
            end;
        until StartPos = 0;

        exit(Parts);
    end;
}