
PARENT = undefined;
IFRAME_PARENT = undefined;

BSXDIV = undefined;

CURRENT_BIGIMAGE_DIMENSIONS = {
    "TOP":0,
    "RIGHT":0,
    "BOTTOM":0,
    "LEFT":0,
}

function initialize() {
    IFRAME_PARENT = window.parent;
    IFRAME = IFRAME_PARENT.document.querySelector("iframe[role='presentation']");
    BSXDIV = IFRAME.parentElement;
    IFRAME.setAttribute("style", "display:none;");
    BSXDIV.setAttribute("style", "display:flex;flex-wrap:wrap;");
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnAfterInitializing", [{ name: "Rasmus"}], false);
}


function AddImage(ImageLink) {
    image_div = document.createElement("div");
    image_div.setAttribute("style", "margin:2px;width:75px;height:75px;overflow:hidden;border:1px solid #ababab;")
    image = document.createElement("img");
    image.src = ImageLink.Thumbnail_Link != '' ? ImageLink.Thumbnail_Link : ImageLink.Image_Link;
    
    $(image_div).hover(
        function(event){
            hover(event, ImageLink);
        }, 
        (event) => unhover(event, ImageLink)
    );
    
    image_div.appendChild(image)

    BSXDIV.appendChild(image_div);
}

function hover(event, ImageLink){
    let bigImage = IFRAME_PARENT.document.createElement("img");
    bigImage.src = ImageLink.Image_Link;
    bigImage.setAttribute("customidentifier", "bigimage");
    
    let bigImageHeight = Number(ImageLink.Image_Height);
    let bigImageWidth = Number(ImageLink.Image_Width);
    let thumbnailHeight = Number(ImageLink.Thumbnail_Height);
    if (ImageLink.Thumbnail_Link == '') {
        thumbnailHeight = ImageLink.Image_Height;
    }
    
    let screenHeight = $(IFRAME_PARENT.document.body).outerHeight();
    let screenWidth = $(IFRAME_PARENT.document.body).outerWidth();

    let pageY = event.pageY;// - (thumbnailHeight*2);
    let pageX = event.pageX;

    let totalY = bigImageHeight + pageY;
    let totalX = 0;
    
    if (totalY > screenHeight) {
        let diff = totalY - screenHeight;
        let percent = (diff / bigImageHeight)
        bigImageHeight = bigImageHeight - (percent*bigImageHeight);
        
        // bigImageHeight = (bigImageHeight * percent) - 150;
        
        bigImageWidth = bigImageWidth - (percent*bigImageWidth);
        
        // bigImageWidth = (bigImageWidth * percent) - 150;
        
    }
    // If Image is wider than 75vw then it will get a different width due to css, so we should account for it.
    if (bigImageWidth > (screenWidth*0.75)) {
        totalX = (screenWidth*0.75) + pageX;
        bigImageWidth = screenWidth * 0.75;
        bigImageHeight = bigImageHeight * ( bigImageWidth / bigImageWidth );
        totalY = bigImageHeight + pageY;
    }
    else {
        totalX = bigImageWidth + pageX;
    }

    if (totalX > screenWidth) {
        pageX = pageX - (totalX - screenWidth)
    }
    
    console.log(event);
    console.log(event.pageX, event.pageY);
    console.log(pageX, pageY);

    bigImage.setAttribute("style", `height:${bigImageHeight}px;width:${bigImageWidth};max-width: 75vw;position:absolute;z-index:9999;top:${pageY}px;left:${pageX}px;border:1px solid #ababab`);
    
    CURRENT_BIGIMAGE_DIMENSIONS.TOP = pageY;
    CURRENT_BIGIMAGE_DIMENSIONS.LEFT = event.pageX;
    CURRENT_BIGIMAGE_DIMENSIONS.BOTTOM = pageY + bigImageHeight;
    CURRENT_BIGIMAGE_DIMENSIONS.RIGHT = pageX + bigImageWidth;

    $(bigImage).on("mouseleave", 
        function(event){
            bigImage.remove();
        }
    )
    IFRAME_PARENT.document.body.appendChild(bigImage);
    
}

function unhover(event, ImageLink){
    let bigImage = IFRAME_PARENT.document.body.querySelector(`[src='${ImageLink.Image_Link}'][customidentifier='bigimage']`);

    if (!$(bigImage).is(":hover")){
        bigImage.remove();
    }

}

