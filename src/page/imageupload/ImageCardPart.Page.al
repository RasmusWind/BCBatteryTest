page 50148 ImageControlAddInPart
{
    Caption = 'Images';
    PageType = CardPart;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            usercontrol(ImageControl; ImageControlAddin)
            {
                ApplicationArea = All;

                trigger OnControlReady()
                begin
                end;

                trigger OnAfterInitializing(Context: JsonObject)
                var
                    ImageLink: Record "Image Link";
                    ImageLinkJson: JsonObject;
                    JsonRecord: Codeunit "Json Record";
                begin
                    if CurrentTableId = 0 then
                        Error('No table id set on ImageControl');
                    if CurrentRecordId = '' then
                        Error('No Record Id set on ImageControl');
                    ImageLink.SetRange("Related Table ID", CurrentTableId);
                    ImageLink.SetRange("Related Record ID", CurrentRecordId);
                    if ImageLink.FindFirst() then begin
                        repeat
                            ImageLinkJson := JsonRecord.Rec2Json(ImageLink);
                            CurrPage.ImageControl.AddImage(ImageLinkJson);
                        until ImageLink.Next() = 0;
                    end;
                end;
            }

        }
    }

    var
        CurrentRecordId: Text;
        CurrentTableId: Integer;

    procedure SetContext(v: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(v);


        SetCurrentTableId(RecRef.Number());
        SetCurrentRecordId(Format(RecRef.RecordId()));
    end;

    procedure SetCurrentRecordId(RecId: Text)
    begin
        CurrentRecordId := RecId;
    end;

    procedure SetCurrentTableId(TableId: Integer)
    begin
        CurrentTableId := TableId;
    end;
}