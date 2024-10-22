controladdin ImageControlAddin
{
    Scripts =
        'https://code.jquery.com/jquery-3.3.1.min.js',
        'scripts/ImageControl.js';

    StartupScript = 'scripts/ImageControlStartup.js';

    HorizontalStretch = true;
    // Define the event that will receive the image URL

    event OnControlReady();

    event OnAfterInitializing(Context: JsonObject);
    procedure AddImage(ImageLink: JsonObject);
}