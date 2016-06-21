function callNativeApp () {
    try {
       // webkit.messageHandlers.callbackHandler.postMessage("Hello from JavaScript");
    } catch(err) {
        console.log('The native context does not exist yet');
    }
}

setTimeout(function () {
           callNativeApp();
           }, 5000);

function redHeader() {
    document.querySelector('h1').style.color = "red";
}

function sendInfo(info){
    try{
        webkit.messageHandlers.callbackHandler.postMessage("" + info);
        //document.querySelector("img_map").src ="https://v3.ehss.net/mobile/getimagenew/username/aileenfernando@gmail.com/password/741852963/image/2"
    }catch(err){
    
    }
}

