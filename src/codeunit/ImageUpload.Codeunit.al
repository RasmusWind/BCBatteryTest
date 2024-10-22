codeunit 50145 "Image Upload"
{
    procedure UploadImagePrompt()
    var
        InStream: InStream;
        OutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        Base64Convert: Codeunit "Base64 Convert";
        Base64Image: Text;
        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        APIUrl: Text[250];
        HttpHeaders: HttpHeaders;
        HttpRequestMessage: HttpRequestMessage;
        HttpContentHeaders: HttpHeaders;
    begin

        if UploadIntoStream('Select Image', '', 'All Files|*.*', FileName, InStream) then begin
            APIUrl := 'http://10.0.191.84:5000/media/upload'; // Replace with your API URL
            HttpRequestMessage.SetRequestUri(APIUrl);
            HttpRequestMessage.Method := 'POST';

            Base64Image := Base64Convert.ToBase64(InStream);

            HttpContent.WriteFrom(Base64Image);
            HttpContent.GetHeaders(HttpContentHeaders);

            HttpContentHeaders.Clear();
            HttpContentHeaders.Remove('Content-Type');
            HttpContentHeaders.Add('Content-Type', 'application/json');

            HttpRequestMessage.Content := HttpContent;

            HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

            if HttpResponseMessage.IsSuccessStatusCode() then begin
                Message('Image uploaded and deleted successfully.');
            end else
                Error('Failed to upload the image. Status Code: %1', HttpResponseMessage.HttpStatusCode());
        end else
            Error('No image selected.');
    end;


    procedure UploadImageAction(Files: List of [FileUpload]; RecRef: RecordRef; RecordId: RecordId): Boolean
    var
        CurrentFile: FileUpload;
        TempInStream: Instream;

        HttpClient: HttpClient;
        HttpContent: HttpContent;
        HttpResponseMessage: HttpResponseMessage;
        HttpRequestMessage: HttpRequestMessage;
        HttpHeaders: HttpHeaders;
        HttpContentHeaders: HttpHeaders;

        ImageNames, ImagesToken, ImageDimensions : JsonToken;
        ThumbnailDimensions, ThumbnailWidthToken, ThumbnailHeightToken, ImageWidthToken, ImageHeightToken : JsonToken;
        FileDataToken, ThumbFileDataToken : JsonToken;
        FileNameToken, ThumbFileNameToken : JsonToken;

        JsonResponse, ParametersJsonObject : JsonObject;

        Data, ResponseText, Base64Image, ThumbFileName, FileName : Text;
        APIUrl: Text[250];

        Base64Convert: Codeunit "Base64 Convert";
        ImageLink: Record "Image Link";
        ImageServerSetup: Record "Image Server Setup";
    begin
        if not ImageServerSetup.FindFirst() then begin
            Error('Missing image server setup. Go to: "Image Server Setup"');
            exit(false);
        end;

        foreach CurrentFile in Files do begin
            CurrentFile.CreateInStream(TempInstream, TEXTENCODING::UTF8);
            APIUrl := ImageServerSetup."POST URL";
            Base64Image := Base64Convert.ToBase64(TempInstream);
            ParametersJsonObject.Add(CurrentFile.FileName, Base64Image);
        end;

        HttpClient.Clear();
        HttpRequestMessage.SetRequestUri(APIUrl);
        HttpRequestMessage.Method := 'POST';

        ParametersJsonObject.WriteTo(Data);

        HttpContent.WriteFrom(Data);
        HttpContent.GetHeaders(HttpContentHeaders);

        HttpContentHeaders.Clear();
        HttpContentHeaders.Remove('Content-Type');
        HttpContentHeaders.Add('Content-Type', 'application/json');

        HttpRequestMessage.Content := HttpContent;

        HttpClient.Send(HttpRequestMessage, HttpResponseMessage);

        if HttpResponseMessage.IsSuccessStatusCode() then begin
            if HttpResponseMessage.Content.ReadAs(ResponseText) then begin
                if JsonResponse.ReadFrom(ResponseText) then begin

                    JsonResponse.Get('images', ImagesToken);
                    foreach ImageNames in ImagesToken.AsArray() do begin
                        if ImageLink.FindLast() then
                            ImageLink."Primary Key" := ImageLink."Primary Key" + 1;
                        ImageLink.Init();

                        if ImageNames.AsArray().Get(0, FileDataToken) then begin
                            FileDataToken.AsArray().Get(0, FileNameToken);
                            FileName := FileNameToken.AsValue().AsText();
                            if ImageServerSetup."GET URL".EndsWith('/') then begin
                                ImageLink."Image Link" := ImageServerSetup."GET URL" + FileName;
                            end else begin
                                ImageLink."Image Link" := ImageServerSetup."GET URL" + '/' + FileName;
                            end;
                            if FileDataToken.AsArray().Get(1, ImageDimensions) then begin
                                ImageDimensions.AsArray().Get(0, ImageWidthToken);
                                ImageDimensions.AsArray().Get(1, ImageHeightToken);
                                ImageLink."Image Width" := ImageWidthToken.AsValue().AsDecimal();
                                ImageLink."Image Height" := ImageHeightToken.AsValue().AsDecimal();
                            end;
                        end;

                        if ImageNames.AsArray().Get(1, ThumbFileDataToken) then begin
                            ThumbFileDataToken.AsArray().Get(0, ThumbFileNameToken);
                            ThumbFileName := ThumbFileNameToken.AsValue().AsText();
                            if ImageServerSetup."GET URL".EndsWith('/') then begin
                                ImageLink."Thumbnail Link" := ImageServerSetup."GET URL" + ThumbFileName;
                            end else begin
                                ImageLink."Thumbnail Link" := ImageServerSetup."GET URL" + '/' + ThumbFileName;
                            end;
                            if ThumbFileDataToken.AsArray().Get(1, ThumbnailDimensions) then begin
                                ThumbnailDimensions.AsArray().Get(0, ThumbnailWidthToken);
                                ThumbnailDimensions.AsArray().Get(1, ThumbnailHeightToken);
                                ImageLink."Thumbnail Width" := ThumbnailWidthToken.AsValue().AsDecimal();
                                ImageLink."Thumbnail Height" := ThumbnailHeightToken.AsValue().AsDecimal();
                            end;
                        end;

                        ImageLink."Related Table ID" := RecRef.Number;
                        ImageLink."Related Record ID" := Format(RecordId);

                        ImageLink.Insert();
                    end;

                end;
            end;
            exit(true);

        end else begin
            Error('Failed to upload the image. Status Code: %1', HttpResponseMessage.HttpStatusCode());
            exit(false)
        end;
    end;
}