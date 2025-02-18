var scxmlHandler = window.scxmlHandler || {};
scxmlHandler.evaReadyPromiseRequestList = [];
scxmlHandler.oauthloginPromiseRequestList = [];
scxmlHandler.isPlatformReady = true;    // false;
scxmlHandler.isCuemeReady = false;
scxmlHandler.cuemeReadyIdFired = false;
scxmlHandler.oauthloginwiname = "_oauthloginwindow";
scxmlHandler.DEBUG_MODE = false;

scxmlHandler.platformReady = function () {
  // console.log("IN Platform Ready." + new Date().getTime());
  scxmlHandler.isPlatformReady = true;
  scxmlHandler.raiseCuemeready();
};

scxmlHandler.cuemeReady = function () {
  // console.log("IN Cueme Platform Ready." + new Date().getTime());
  scxmlHandler.isCuemeReady = true;
  scxmlHandler.raiseCuemeready();
};

scxmlHandler.raiseCuemeready = function (cuemeAppLaunchParams, cuemeAppRestoreParams) {

  // console.log("raiseCuemeready isPlatformReady=" + scxmlHandler.isCuemeReady +
  //   " isPlatformReady=" + scxmlHandler.isCuemeReady +
  //   " firedCuemeReady=" + scxmlHandler.cuemeReadyIdFired
  // );
  if (!scxmlHandler.cuemeReadyIdFired && scxmlHandler.isPlatformReady && scxmlHandler.isCuemeReady) {
    if (window.mmi) {
      scxmlHandler.cuemeReadyIdFired = true;
      var eventsrc = "sendCuemeEvent";
      window.mmi.eventOccured("click", "cuemeReadyId", "", eventsrc);
    } else if (window.sendCUEMEevent) {
      scxmlHandler.cuemeReadyIdFired = true;
      window.sendCUEMEevent("click", "cuemeReadyId", "");
    }

    // window.mmi.eventOccured("click", "cuemeReadyId", "");
    if (window.cuemeLogText) {
      // console.log(window.cuemeLogText);
    }

    // console.log("platform is ready at " + new Date().getTime());

    scxmlHandler.evaReadyPromiseRequestList.forEach(p => {
      p._resolve();
    });

  } else {
    // console.log("Cueme is NOT Ready.");
  }

};

/**
* Use this call if multiple controllers are waiting on cuemeready
*/
scxmlHandler.onEvaPlatformReady = function () {
  return new Promise((resolve, reject) => {

    if (scxmlHandler.cuemeReadyIdFired) {
      resolve();
    } else {
      var consumeRequest_ = {
        _resolve: resolve,
        _reject: reject
      };
      scxmlHandler.evaReadyPromiseRequestList.push(consumeRequest_);
    }

  });
}

scxmlHandler.openURLInDocManager = function (URL, title, pprodtype) {
  // console.log("Open news url : ", URL, title);
  var lmimetype = "text/html";
  if (pprodtype === "pdf") {
    lmimetype = "application/pdf";
  }
  var config = {
    // Constructed URL should be passed to doc-manager to fetch byte content of the particular attachment.
    "docId": URL,
    "displayName": title,
    "config": {
      "enableNavigation": true,
      "enableScreenshot": false,
      "enableSave": true,
      "enableShareOutside": true,

      // enableNavigation to be true to allow changing location.href in html to raise uievent from docManager
      // "enableShare": true,
      // "enableOpenOutside": true
    },
    "appMetadata": {
      "applicationName": title,
      "docId": URL,
      "mimeType": lmimetype
    }
  };
  if (window.sendCUEMEevent) {
    sendCUEMEevent("click", "setDocumentConfigObj", JSON.stringify(config));
  }

  if (window.sendCUEMEevent) {
    sendCUEMEevent("click", "openDocManager", URL);
  } else {
    window.open(URL, "_newin");
  }

}

scxmlHandler.openNewindow = function (aurl, pwiname, header) {
  if (window.sendCUEMEevent) {

    var winobj = {
      url: aurl,
      showClose: true,
      progressBar: {
        visible: true
      },
      toolbar: {
        "padding-top": "10px",
        "padding-bottom": "10px",
        title: {
          text: header,     // $host shows the host name as title. or provide a string
          backgroundColor: "#DDDDDD",
          textColor: "#000000",
          style: "normal"
        },
        closeButton: {
          visible: true,         // true|false. defaults: true
          text: "Back",         // Shows a button with text. On iOS it defaults to "Done", on Android a close icon is shown
          showIcon: false,     // true|false. Shows an image. If text is provided a text button is shown
          align: "left",        // "left"|"right". Defaults to left
          textColor: "#1866A3",
          style: "normal"
        }
      }
    };

    cueme_openWindow(JSON.stringify(winobj), pwiname ? pwiname : "_newindow");

  }
};

scxmlHandler.exitApp = function () {
  sendCUEMEevent("click", "exitApplication");
}

scxmlHandler.getAjax = function (obj) {

  /* obj {
    data: "",
    headers: "",
    method: "", // GET, POST
    type: "",  // JSON
    url: "",
  }
  */

  return new Promise((resolve, reject) => {
    var httpObj = new CuemeXmlHttpRequest();

    httpObj.readErrorResponse = true;
    httpObj.readResponseHeaders = true;
    // httpObj.timeout = 60000 // can be set

    if (obj.headers) {
      for (let headerName in obj.headers) {
        httpObj.setRequestHeader(headerName, obj.headers[headerName]);
      }
    }

    httpObj.open(obj.method, obj.url, true);
    httpObj.onreadystatechange = function () {
      if (httpObj.status == 200) {
        // JSON Response
        if (obj.type == "JSON") {
          try {
            const JSONResp = JSON.parse(httpObj.responseText);
            resolve(JSONResp);
          } catch (error) {
            reject("JSON Parse Error : " + httpObj.responseText);
          }
          // NORMAL HTML Response
        } else {
          resolve(httpObj.responseText);
        }
      } else {
        reject("Could not fetch : " + httpObj.status);
      }
    };
    httpObj.send(obj.data);
  });

}

scxmlHandler.setAgentChatIcon = function () {
  var avatarsections = document.querySelectorAll("div.webchat__imageAvatar__image");
  if (avatarsections) {
    var lastavatr = avatarsections[avatarsections.length - 1];
    if (lastavatr) {
      var curimg = lastavatr.childNodes[0];
      if (curimg) {
        curimg.src = "../assets/images/eva_chatboticon.svg";
      }
    }
  }
}

scxmlHandler.hideAllConversationMessages = function () {
  var lItems = document.querySelectorAll("ul.webchat__basic-transcript__transcript > li");
  if (lItems) {
    lItems.forEach(function (pItem) {
      if (pItem && pItem.style) {
        pItem.style.display = "none";
      }
    });
  }
}