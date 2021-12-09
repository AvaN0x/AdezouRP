// ------------------------------------------- //
// -------- MADE BY GITHUB.COM/AVAN0X -------- //
// --------------- AvaN0x#6348 --------------- //
// ------------------------------------------- //

window.addEventListener('message', function (event) {
    (async () => {
        const canvas = document.getElementById("base64Canvas");
        canvas.width = event.data.width;
        canvas.height = event.data.height;

        const context = canvas.getContext("2d");
        const image = new Image();
        image.src = event.data.base64;

        // Await image to be loaded
        await image.decode();

        context.drawImage(image, 0, 0);
        const ImageData = context.getImageData(0, 0, canvas.width, canvas.height);

        fetch(`https://${GetParentResourceName()}/base64treated`, {
            method: 'POST',
            body: JSON.stringify({
                argb: ImageData.data,
                id: event.data.id,
            })
        });
    })();
});