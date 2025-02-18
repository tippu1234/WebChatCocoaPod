//
//  EVAWebChatView.swift
//  WebChat
//
//  Created by Raghavendra on 16/04/24.
//

import Foundation
import UIKit
import WebKit
import MobileCoreServices

public protocol EVAWebChatBotDelegate {
    
    func showWebChatBotSuccess(_ response:[String:Any])
    func showWebChatBotFail(_ errorResponse:[String:Any])
    
    func closeWebChatBotSuccess(_ response:[String:Any])
    func closeWebChatBotFail(_ errorResponse:[String:Any])
    
    func minimizeWebChatBotSuccess(_ response:[String:Any])
    func minimizeWebChatBotFail(_ errorResponse:[String:Any])
}

class EVAWebChatView:UIView, WKUIDelegate, UINavigationControllerDelegate {
    
    static let frameworkBundleID  = "com.openstream.WebChat";       // Static constant frameworkBundleID, which holds the identifier of the bundle associated with the WebChat framework.
    let frameworkBundle = Bundle(identifier: frameworkBundleID)     // Optional Bundle object.
    public var webPageURL: String?                                  // String representing the URL of the web page to be loaded in the WKWebView
    var mViewId_: String?                                           // String representing view ID
    var mMainDocumentChanging_ = false                              // Boolean indicating whether the main document is being changed.
    var mLoadingCounter_: Int?                                      // Integer representing a loading counter, presumably used internally for tracking loading progress.
    var mPageLoadingComplete_ = false                               // Boolean indicates whether page loading is complete
    var mDisableCuemeInteraction_ = false                           // Boolean indicating whether Cueme interaction is disabled.
    var mCuemeJsContent_: String?                                   // String representing JavaScript content related
    var mCuemeChildJsContent_: String?                              // String representing JavaScript content for child components
    let ErrorPageUrl = "resource://workbench/application-error.html" // String representing the URL for an error page
    var webView: WKWebView!                                         // Property represents a WKWebView instance used for displaying web content.
    var initialConfiguration: [String:Any] = [:]                    // Property holds the initial configuration parameters for the WebChat module.
    var sourceVC: UIViewController?                                 // Property represents the source view controller
    var superView: UIView?                                          // Property represents the superView
    var evaWebChatBotDelegate:EVAWebChatBotDelegate?                // Instance of EVAWebChatBotDelegate property.

    // Creates a shared instance of WKProcessPool
    static let wKProcessPoolSharedInstanceWkProcessPoolInstance = {
        print("EVAWebChatView: CuemeWebViewConfigurator NOT found... creating a new WKProcessPool")
        var wkProcessPoolInstance = WKProcessPool()
        return wkProcessPoolInstance
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: init
    /// Initialises with frame
    /// - Parameter frame: CGRect
    /// - Returns: EVAWebChatView
    class func initWith(frame: CGRect) -> EVAWebChatView? {
        // retrieves the bundle that contains the class EVAWebChatView.
        let bundle = Bundle(for: EVAWebChatView.self)
        
        // attempts to load a nib file named "EVAWebChatView" from the bundle.
        if let evaWebChatView = bundle.loadNibNamed("EVAWebChatView", owner: nil)?.last as? EVAWebChatView {
            
            // sets the frame of the evaWebChatView to the provided frame.
            evaWebChatView.frame = frame
            return evaWebChatView
        } else {
            return nil
        }
    } 
    
    //MARK: injectWkIphoneJs
    /// Injects the WKWebView iPhone JavaScript content into the given WKWebView configuration.
    /// - Parameter webConfig: WKWebViewConfiguration
    func injectWkIphoneJs(_ webConfig: WKWebViewConfiguration?) {

        if mCuemeJsContent_ == nil {
            let bundle = Bundle(for: EVAWebChatView.self)
            let filepath = bundle.path(forResource: "wkiphone", ofType: "txt")
            
            var content: String?
            
            do {
                content = try String(contentsOfFile: filepath ?? "", encoding: .utf8)
            } catch {
                
            }
            
            if content == nil {
                mCuemeJsContent_ = ""
                print("EVAWebChatView : wkiphone.txt : file is missing from the package")
            } else {
                mCuemeJsContent_ = content
                print("EVAWebChatView : wkiphone.txt : content : \n \(mCuemeJsContent_ ?? "")")
            }
        }
        
        if (mCuemeJsContent_?.count ?? 0) > 0 {
            DispatchQueue.main.async {
                let wkscript = WKUserScript(source: self.mCuemeJsContent_ ?? "", injectionTime: .atDocumentStart, forMainFrameOnly: true)
                webConfig?.userContentController.addUserScript(wkscript)
            }
        }

    }
    
    //MARK: setInitialConfiguration
    /// Configures the initial settings of the EVAWebChatView by executing JavaScript code within its WKWebView instance.
    func setInitialConfiguration() {
        print("EVAWebChatView : setInitialConfiguration : start")
        
        // Convert the initialConfiguration dictionary to a JSON string.
        let jsonObject = JSONObject(dictionary: NSMutableDictionary(dictionary: initialConfiguration))
        let configString = "evabot_setConfiguration('\(jsonObject.toString())');"
        
        // Evaluate the JavaScript code to set the initial configuration in the web view.
        webView.evaluateJavaScript(configString, completionHandler: nil)
        
        // Create a test string to raise a Cueme event (e.g., taking a picture).
        let testString = "raiseCuemeEvent('takePicture', null, null, null);"

        // Evaluate the JavaScript code to raise the Cueme event.
        webView.evaluateJavaScript(testString) { navUserAgent, error in
            if(error != nil) {
                
            }
        }

        print("EVAWebChatView : setInitialConfiguration : end")
    }
    
    //MARK: reloadWebPage
    /// Reloads webpage.
    func reloadWebPage() {
        webView.reload()
    }
    
    //MARK: loadWebView
    /// Sets up and loads the WKWebView within the EVAWebChatView.
    func loadWebView() {
        
        let webViewConfiguration = WKWebViewConfiguration()
        
//        webViewConfiguration.preferences.javaScriptEnabled = true
        // Add the current object as a user content controller for the "evabotwebview" message handler.
        webViewConfiguration.userContentController.add(self, name: "evabotwebview")

        // Set up URL scheme handlers for "resource" and "cuemedata".
        webViewConfiguration.setURLSchemeHandler(self, forURLScheme: "resource")
        webViewConfiguration.setURLSchemeHandler(self, forURLScheme: "cuemedata")
        injectWkIphoneJs(webViewConfiguration)
        
        // Create a WKWebView instance with the provided frame and configuration.
        webView = WKWebView(frame: self.frame, configuration: webViewConfiguration)
        
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        } else {
            // Fallback on earlier versions
        }
        
        // Set Up Auto Layout for the WKWebView
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(webView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[webView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["webView": webView!]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[webView]|",
                                                                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                views: ["webView": webView!]))
        
        
        
        // Set the UI and navigation delegates for the WKWebView.
        webView.uiDelegate = self
        webView.navigationDelegate = self
        // Load the web page using the provided URL.
        webView.load(URLRequest(url:URL(string:webPageURL ?? "")!))
//        webView.loadFileURL(URL(fileURLWithPath: webPageURL ?? ""), allowingReadAccessTo: URL(fileURLWithPath: webPageURL ?? ""))
    }
    
    //MARK: takePicture
    /// Initiate the process of taking a picture using the camera.
    func takePicture() {
        
        // Access the shared instance of the EVAWebChatCameraHandler.
        let cameraHandler = EVAWebChatCameraHandler.sharedInstance
        
        cameraHandler.delegate = self
        if let sourceVC = sourceVC {
            cameraHandler.launchCameraUI(viewcontroller: sourceVC)
        } else {
            
        }
        
    }
    
    //MARK: showChatBotView
    /// Displays the chatbot view within its designated superView.
    func showChatBotView() {
        // Add the current view (presumably the chatbot view) as a subview to the superView.
        superView?.addSubview(self)
        // Bring the chatbot view to the front, ensuring it's visible above other subviews.
        superView?.bringSubviewToFront(self)
        if(evaWebChatBotDelegate != nil) {
            var resultJSON:[String:Any] = [:]
            resultJSON["message"] = "Show chat bot view success!"
            evaWebChatBotDelegate?.showWebChatBotSuccess(resultJSON)
        }
    }
    
    //MARK: closeChatBotView
    /// Removes the chatbot view from its superview.
    func closeChatBotView() {
        // Remove the chatbot view from its superview, effectively hiding it from the user's view.
        self.removeFromSuperview()
        if(evaWebChatBotDelegate != nil) {
            var resultJSON:[String:Any] = [:]
            resultJSON["message"] = "Close chat bot view success!"
            evaWebChatBotDelegate?.closeWebChatBotSuccess(resultJSON)
        }
    }
    
    //MARK: minimizeChatBotView
    /// Removes chatbot view from its superview, effectively hiding it from the user's view.
    func minimizeChatBotView() {
        // Remove the chatbot view from its superview, effectively hiding it from the user's view.
        self.removeFromSuperview()
        if(evaWebChatBotDelegate != nil) {
            var resultJSON:[String:Any] = [:]
            resultJSON["message"] = "Minimize chat bot view success!"
            evaWebChatBotDelegate?.minimizeWebChatBotSuccess(resultJSON)
        }
    }
}

//MARK: - EVAWebChatCameraHandlerDelegate Methods -
extension EVAWebChatView:EVAWebChatCameraHandlerDelegate {
    
    //MARK: capturedImageSuccess
    /// Called when the image is captured successfully.
    /// - Parameter image: UIImage
    func capturedImageSuccess(image: UIImage) {
        print("Take picture success!")
        
        // Convert the captured image to PNG data.
        let imageData = image.pngData()
        // Convert the PNG data to a base64-encoded string.
        let imageBase64String = imageData?.base64EncodedString(options: .init(rawValue: 0)) ?? ""
        
        //Send back captured image to webView
        webView.evaluateJavaScript("evabot_pictureData('\(imageBase64String)');", completionHandler: nil)
//            webView.evaluateJavaScript("callback({id: \("id-Test"), status: 'success', args: ...})", completionHandler: nil)
    }
    
    //MARK: capturedImageFail
    /// Called when capture of image is failed.
    func capturedImageFail() {
        //Implement fail callback
        print("Unable to take picture!")
    }
    
    
}

//MARK: - WKNavigationDelegate Methods -
extension EVAWebChatView:WKNavigationDelegate {

    
    //MARK: webView:didStartProvisionalNavigation:
    /// Tells the delegate that navigation from the main frame has started.
    /// - Parameters:
    ///   - webView: The web view that is loading the content.
    ///   - navigation: The web view that is loading the content.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        print("EVAWebChatView : didStartProvisionalNavigation : navigation=\(navigation ?? WKNavigation())")
    }
    
    //MARK: webView:didCommitNavigation:
    /// Tells the delegate that the web view has started to receive content for the main frame.
    /// - Parameters:
    ///   - webView: The web view that is loading the content.
    ///   - navigation: The navigation object that uniquely identifies the load request.
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("CuemeWebView : didCommit : navigation=\(navigation ?? WKNavigation())")

        print("EVAWebChatView : webViewDidStartLoad : request = \(webView.url?.absoluteString ?? "")")

        if mMainDocumentChanging_ {
            
            mLoadingCounter_? += 1
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
        }
    }
    
    //MARK: webView:didFailNavigation:withError:
    /// Tells the delegate that an error occurred during navigation.
    /// - Parameters:
    ///   - webView: The web view that reported the error.
    ///   - navigation: The navigation object for the operation. This object corresponds to a WKNavigation object that WebKit returned when the load operation began. You use it to track the progress of that operation.
    ///   - error: The error that occurred.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("CuemeWebView : %s : navigation=\(navigation ?? WKNavigation())")
    }

    //MARK: webView:didFailProvisionalNavigation:withError:
    /// Tells the delegate that an error occurred during the early navigation process.
    /// - Parameters:
    ///   - webView: The web view that called the delegate method.
    ///   - navigation: The navigation object for the operation. This object corresponds to a WKNavigation object that WebKit returned when the load operation began. You use it to track the progress of that operation.
    ///   - error: The error that occurred.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        print("CuemeWebView : %s : navigation=%@ error=\(error)")
        print("EVAWebChatView : didFailLoadWithError : Error loading URL [%@]; Error Description = \(error.localizedDescription)")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let failingUrlString = (error as NSError).userInfo[NSURLErrorFailingURLStringErrorKey] as? String
        
        if isApplicationErrorPage(failingUrlString) {
            return
        }
        
        if (((error as NSError).domain == "NSURLErrorDomain") && (error as NSError).code == -999) || (((error as NSError).domain == "WebKitErrorDomain") && (error as NSError).code == 102) || (((error as NSError).domain == "WebKitErrorDomain") && (error as NSError).code == 204) {
            
            print("EVAWebChatView : didFailLoadWithError : Ignoring error \(error) and calling didFinishload")
            self.webView(webView, didFinish: navigation)
            return
        }
        
        if mMainDocumentChanging_ ?? true {
            mLoadingCounter_? -= 1
        }
        
        if mMainDocumentChanging_ == false || mLoadingCounter_ ?? 0 > 0 {
            
            print("Warning: Loading URL \(failingUrlString ?? "") failed; Error Description = \(error.localizedDescription)")
            return
        }
        
        mMainDocumentChanging_ = false

        /*if mViewId_ == nil {
            mComponent_?.raiseIMEvent(Event.URLChangeFail.rawValue, target: "_main", data: failingUrlString)
        } else {
            mComponent_?.raiseIMEvent(Event.URLChangeFail.rawValue, target: mViewId_, data: failingUrlString)
        }*/
        
        let isNotAboutSchemeOrHashUrl = webView.url?.scheme != "about" && (webView.url?.fragment?.isEmpty ?? true)

        if isNotAboutSchemeOrHashUrl {
            
            print("EVAWebChatView: Error loading URL \(failingUrlString ?? ""); Error Description = \(error.localizedDescription)")
            
            let errorStr = error.localizedDescription
            let errorCode = (error as NSError).code
            let errorDomain = (error as NSError).domain

            /*let error = WorkbenchError(errorCode: WorkbenchError.page_LOAD_ERROR())
            error?.reason = errorStr
            error?.addlInfo.setObject(NSNumber(value: Int32(errorCode)).stringValue, forKey: "nativeErrorCode")
            error?.addlInfo.setObject(failingUrlString, forKey: "url")
            error?.addlInfo.setObject(errorDomain, forKey: "errorDomain")
            
            mLoadError_ = error?.toJSONObject()
            
            showErrorPage()
            completeProgress()*/
            
        } else {
            
            print("EVAWebChatView : didFailLoadWithError : Warning: Loading URL \(failingUrlString ?? "") failed; Error Description = \(error.localizedDescription)")
        }
        
    }
    
    //MARK: webView:didFinishNavigation:
    /// Tells the delegate that navigation is complete.
    /// - Parameters:
    ///   - webView: The web view that loaded the content.
    ///   - navigation: The navigation object that finished.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("CuemeWebView : \(#function) : navigation=\(navigation ?? WKNavigation())")

        do {
            print("EVAWebChatView : webViewDidFinishLoad : viewId=\(mViewId_ ?? ""), request.URL = \(webView.url?.absoluteString ?? "")")
            
            if isApplicationErrorPage(webView.url?.absoluteString ?? "") {
                errorPageLoadComplete(webView)
                return
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            
            if (mMainDocumentChanging_ == false) {
                print("EVAWebChatView : Main Document has not changed. Ignore didFinishLoad : viewId: \(mViewId_ ?? "")")
                return
            }
            
            mLoadingCounter_? -= 1
            if mLoadingCounter_ ?? 0 > 0 {
                
                print("Loading still in progress: viewId: \(mViewId_ ?? "")")
                return
            }
            
//            completeProgress()
            
            print("EVAWebChatView : Main document has changed. Preparing Cueme")
            
            mMainDocumentChanging_ = false
            
            if mViewId_ == nil {
                print("EVAWebChatView : webViewDidFinishLoad : Handling the main webview document load complete.")
                
//                mComponent_?.raiseIMEvent(Event.URLChanged.rawValue, target: "_main", data: mWebView_?.url?.absoluteString ?? "")
                
                if let mainDocumentUrl = webView.url {
//                    let appContext = getApplicationContext(mainDocumentUrl)
                    
                    
//                    if mCurAppContext_ != appContext {
//                        mNewHost_ = true
//                        mCurAppContext_ = appContext
//                    }
//                    
//                    mFiredCuemeReady_ = false
//                    mCurTitle_ = webView.title
                    
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            } else {
//                mComponent_?.raiseIMEvent(Event.URLChanged.rawValue, target: mViewId_, data: webView.url?.absoluteString ?? "")
                
                print("EVAWebChatView : webViewDidFinishLoad : Handling the webview Id : \(mViewId_ ?? "") document load complete.")
            }
            
            setInitialConfiguration()
            
        }

    }
    
    //MARK: webView:didReceiveServerRedirectForProvisionalNavigation:
    /// Tells the delegate that the web view received a server redirect for a request.
    /// - Parameters:
    ///   - webView: The web view that is loading the content.
    ///   - navigation: The navigation object that received a server redirect.
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        print("CuemeWebView : %s : navigation=%\(navigation ?? WKNavigation())")
        
    }
    
    //MARK: webView:decidePolicyForNavigationAction:preferences:decisionHandler:
    /// Asks the delegate for permission to navigate to new content based on the specified preferences and action information.
    /// - Parameters:
    ///   - webView: The web view from which the navigation request began.
    ///   - navigationAction: Details about the action that triggered the navigation request.
    ///   - decisionHandler: A completion handler block to call with the results about whether to allow or cancel the navigation.
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("CuemeWebView : %s : navaction=\(navigationAction)")
        let url = navigationAction.request.url
        let scheme = url?.scheme
        let requestString = url?.absoluteString
        let request = navigationAction.request

        print("CuemeWebView : navaction=\(navigationAction)")

        print("EVAWebChatView : shouldStartLoadWithRequest \(navigationAction.request). Scheme = \(scheme ?? ""). Webview Id : \(mViewId_ ?? "")")

        if url?.scheme == "tel" || url?.scheme == "sms" ||
            url?.scheme == "mailto" ||
            url?.host == "itunes.apple.com" {
            
            if UIApplication.shared.canOpenURL(navigationAction.request.url ?? URL(fileURLWithPath: "")) {
                
                UIApplication.shared.open(navigationAction.request.url ?? URL(fileURLWithPath: ""))
                decisionHandler(.allow)
                return
            }
        }

//        if isSupportedCuemeUrl(url ?? URL(fileURLWithPath: "")) == false {
//            print("UnSupported Cueme url. Proceed with loading but disable cueme interaction")
//            decisionHandler(.allow)
//            return
//        }

    
        if isApplicationErrorPage(navigationAction.request.url?.absoluteString) {
            decisionHandler(.allow)
            return
        }

        
        if requestString?.hasSuffix("scxml") ?? false {
            if mViewId_ == nil {
//                mComponent_?.processSCXML(requestString, state: nil)
            }
            decisionHandler(.cancel)
            return
        }

//        mLoadError_ = nil

        let isMainDocAndNotAboutScheme = request.url == request.mainDocumentURL &&
        (request.url?.scheme != "about")
        if isMainDocAndNotAboutScheme {
            
            var strippedWebViewRequestUrl = ""
            
            if (webView.url != nil) {
                
//                strippedWebViewRequestUrl = URLUtils.stripFragments(fromUrlString: webView.url?.absoluteString)
                
            }
            
//            let strippedRequestUrl = URLUtils.stripFragments(fromUrlString: request.url?.absoluteString) ?? ""
            
//            if strippedWebViewRequestUrl.count != 0 && ((request.url?.absoluteString.hasPrefix(strippedRequestUrl + "#")) == true) && (strippedRequestUrl == strippedWebViewRequestUrl) {
//                print("EVAWebChatView: shouldStartLoadWithRequest : Hash URL requested")
//                decisionHandler(.allow)
//                return
//            }
            
            print("EVAWebChatView: shouldStartLoadWithRequest : Starting New Document load.")
            
            mMainDocumentChanging_ = true
            mLoadingCounter_ = 0
            mPageLoadingComplete_ = false
            
            var webviewId = mViewId_
            
            if webviewId == nil {
                webviewId = "main"
            }
            
//            mComponent_?.raiseIMEvent(Event.URLChanging.rawValue, target: webviewId, data: request.url?.absoluteString ?? "")
            
            
//            if request.url?.scheme == "http" || request.url?.scheme == "https" {
//                startProgress()
//            }
//            
//            if mUseHostNameAsTitleText_ ?? true && mViewId_?.count ?? 0 > 0 {
//                mToolbarLabel_?.text = request.url?.host
//                mToolbarLabel_?.sizeToFit()
//            }
        }

        decisionHandler(.allow)

    }
    
    //MARK: webView:decidePolicyForNavigationResponse:decisionHandler:
    /// Asks the delegate for permission to navigate to new content after the response to the navigation request is known.
    /// - Parameters:
    ///   - webView: The web view from which the navigation request began.
    ///   - navigationResponse: Descriptive information about the navigation response.
    ///   - decisionHandler: A completion handler block to call with the results about whether to allow or cancel the navigation.
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        print("CuemeWebView : navresponse=\(navigationResponse)")

        decisionHandler(.allow)

//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//            guard let bWebView = self?.mWebView_ else {
//                return
//            }
//            
//            // Save cookies to System cookie store to allow http cookies to pick it up.
//            CuemeWebViewCookieManager.copyWKHTTPCookieStoreToNSHTTPCookieStorage(for: bWebView, withCompletion: {
//                
//            })
//        }
    }
    
    //MARK: webView:didReceiveAuthenticationChallenge:completionHandler:
    /// Asks the delegate to respond to an authentication challenge.
    /// - Parameters:
    ///   - webView: The web view that receives the authentication challenge.
    ///   - challenge: The authentication challenge.
    ///   - completionHandler: A completion handler block to execute with the response.
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        print("CuemeWebView : %s : challenge=\(challenge)")
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
        
//        let challengeHandler = CuemeURLSessionDelegate.sharedIntance(mLogger_).challengeHandler()

//        if challengeHandler == nil || challengeHandler?.handle(challenge, completionHandler: completionHandler) == false {
//            completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
//        }
    }
}

//MARK: - extension to WKURLSchemeHandler protocol -
extension EVAWebChatView: WKURLSchemeHandler{
    
    //MARK: webView(_:start:)
    /// Asks your handler to begin loading the data for the specified resource.
    /// - Parameters:
    ///   - webView: The web view that requires the resource.
    ///   - urlSchemeTask: The task object that identifies the resource to load.
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        
        print("EVAWebChatView : startURLSchemeTask=\(urlSchemeTask.request.url?.absoluteString ?? "")")

        let url = urlSchemeTask.request.url
        let urlString = url?.description ?? ""

        print("EVAWebChatView :: startLoading :: start :: \(urlString)")

       
        //urlString = StringUtil.removeQueryParams(fromUrlString: urlString)

        do {
            var returnData: Data?

            /*let agent = URLAgent(urlString, mode: URLAgent.get(), logger: mLogger_, appContext: mAppContext_)
            agent?.execute()
            let status = agent?.getStatus()
            if status == 200 {
                returnData = agent?.getResponse()
            }*/
            
            returnData = readContentOfResourceFile(urlString)

            if returnData != nil {
                var mimeType = EVAWebChatView.getMimeType(urlString)
                if mimeType == nil {
                    mimeType = "text/plain"
                }

                print("EVAWebChatView : MimeType: \(mimeType ?? ""). Content length: \(returnData?.count ?? 0)")

                var response: URLResponse?
                let useHttpResponseCodes = false //PropertyReader.getBooleanProperty("webview.customProtocolUseHttpResponse", defaultValue: false)
                let isMediaExtension = isMediaExtension(url?.pathExtension)
                if useHttpResponseCodes && !isMediaExtension {
                    response = HTTPURLResponse(url: urlSchemeTask.request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [
                        "Cache-Control": "no-cache",
                        "Content-Type": "mimeType",
                        "Access-Control-Allow-Origin": "*"
                    ])
                } else {
                    response = URLResponse(url: urlSchemeTask.request.url ?? URL(fileURLWithPath: ""), mimeType: mimeType, expectedContentLength: returnData?.count ?? 0, textEncodingName: nil)
                }

                urlSchemeTask.didReceive(response ?? URLResponse())
                urlSchemeTask.didReceive(returnData ?? Data())
            } else {
                print("EVAWebChatView :: startLoading :: error... return")
                urlSchemeTask.didFailWithError(NSError(domain: "CuemeResourceHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not found"]))
                return
            }

            urlSchemeTask.didFinish()
        }
        print("EVAWebChatView :: startLoading :: done")

    }
    
    func readContentOfResourceFile(_ filePath:String) -> Data? {
        let bundle = Bundle(for: EVAWebChatView.self)
        let fm = FileManager.default
        var absPath: String?
        absPath = filePath.replacingOccurrences(of: "resource:/", with: "")
        
        absPath = (bundle.resourcePath ?? "") + (absPath ?? "")
        if !fm.fileExists(atPath: absPath ?? "") {
            return nil
        } else {
            return NSData(contentsOfFile: absPath ?? "") as Data?
        }
    }
    
    //MARK: webView(_:stop:)
    /// Asks your handler to stop loading the data for the specified resource.
    /// - Parameters:
    ///   - webView: The web view that asked you to stop loading the resource.
    ///   - urlSchemeTask: The task object that identifies the resource the web view no longer needs.
    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        
    }
    
    //MARK: isMediaExtension
    /// Checks if the path has media extensions.
    /// - Parameter pathExtension: String
    /// - Returns: Bool
    func isMediaExtension(_ pathExtension: String?) -> Bool {
        let mediaExtensions = [
            "m4v",
            "mov",
            "mp4",
            "aac",
            "ac3",
            "aiff",
            "au",
            "flac",
            "m4a",
            "mp3",
            "wav"
        ]
        if mediaExtensions.contains(pathExtension?.lowercased() ?? "") {
            return true
        }
        return false
    }
    
}

//MARK: - WKScriptMessageHandler Methods -
extension EVAWebChatView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "evabotwebview" {
            if let messageBody = message.body as? NSDictionary {
                var eventName = messageBody.object(forKey: "name") as? String
                var source = messageBody.object(forKey: "value") as? String
                var value = messageBody.object(forKey: "data") as? String
                var eventSrc = messageBody.object(forKey: "eventSrc") as? String
                
                if eventName?.count == 0  {
                    eventName = nil
                }
                if source?.count == 0  {
                    source = nil
                }
                if value?.count == 0  {
                    value = nil
                }
                if eventSrc?.count == 0  {
                    eventSrc = nil
                }
                
                if eventName == nil || (eventName == "log") == false {
                    print("EVAWebChatView : eventOccured : eventName=\(String(describing: eventName)) source=\(String(describing: source)) value=\(String(describing: value)) eventsrc=\(String(describing: eventSrc))")
                }
                
                switch eventName {
                    case "takePicture":
                        takePicture()
                        break
                    case "closeView":
                        closeChatBotView()
                        break
                    default :
                        break
                }
            }
        } else if message.name == "cuememmi" {
            _ = message.body
            
            /*if body is NSDictionary {
                
                let jsCuemeEvtData = body as? NSDictionary
                
                var eventName = jsCuemeEvtData?.object(forKey: "name") as? String
                var source = jsCuemeEvtData?.object(forKey: "value") as? String
                var value = jsCuemeEvtData?.object(forKey: "data") as? String
                var eventSrc = jsCuemeEvtData?.object(forKey: "eventSrc") as? String
                
                if eventName?.count == 0  {
                    eventName = nil
                }
                if source?.count == 0  {
                    source = nil
                }
                if value?.count == 0  {
                    value = nil
                }
                if eventSrc?.count == 0  {
                    eventSrc = nil
                }
                
                if eventName == nil || (eventName == "log") == false {
                    print("EVAWebChatView : eventOccured : eventName=\(String(describing: eventName)) source=\(String(describing: source)) value=\(String(describing: value)) eventsrc=\(String(describing: eventSrc))")
                }
                
                switch eventName {
                
                    case "click", "focus", "blur", "change" :
                        
                        let listeningElements = mComponent_?.getDOMEvents()?[eventName ?? ""] as? NSMutableArray
                        
                        if eventSrc == "sendCUEMEevent"  || ((listeningElements?.contains(source ?? "")) != nil) {
                            
                            print("EVAWebChatView: eventOccured : raising event : eventName=\(String(describing: eventName))")
                            
                            mComponent_?.raiseIMEvent(eventName, target: source, data: value)
                        }
                        
                        break
                        
                    case "log":
                        
                        if source != nil {
                            if value == nil {
                                print("CONSOLE(d) : " + (source ?? ""))
                            }
                        } else {
                            
                            let level = value?.lowercased()
                            
                            switch level {
                                
                            case "debug":
                                
                                print("CONSOLE(d) :" + (source ?? ""))
                                break
                                
                            case "warn":
                                
                                print("CONSOLE(d) :" + (source ?? ""))
                                break
                                
                            case "error":
                                
                                print("CONSOLE(d) :" + (source ?? ""))
                                break
                                
                            case "trace":
                                
                                print("CONSOLE(d) :" + (source ?? ""))
                                break
                                
                            default:
                                break
                            }
                        }
                        break
                        
                    case "playSound" :
                        
                        print("CuemeWebView playSound request")
                        
                        DispatchQueue.main.async {
                            TonePlayer.playBeep(source ?? "", completion: {
                                
                            })
                        }
                        break
                        
                    case "hapticFeedback":
                        
                        print("CuemeWebView hapticFeedback request")
                        
                        DispatchQueue.main.async {
                            let generator = HapticFeedbackGenerator()
                            generator.vibrate(source ?? "", logger: self.mLogger_)
                        }
                        
                        break
                        
                    case "playSoundWithHapticFeedback":
                        
                        print("CuemeWebView playSoundAndHapticFeedback request")
                        
                        DispatchQueue.main.async {
                            TonePlayer.playBeep(source ?? "", completion: {
                                
                            })
                            let generator = HapticFeedbackGenerator()
                            generator.vibrate(source ?? "", logger: self.mLogger_)
                        }
                        break
                        
                    case "cuemeKeyboardHide":
                        
                        print("CuemeWebView cuemeKeyboardHide request")
                        DispatchQueue.main.async {
                            self.mWebView_?.endEditing(true)
                        }
                        
                        break
                        
                    case "cuemeCopyCookiesToSystem":
                        
                        print("CuemeWebView cuemeKeyboardHide request")
                        DispatchQueue.main.async {
                            CuemeWebViewCookieManager.copyWKHTTPCookieStoreToNSHTTPCookieStorage(for: self.mWebView_ ?? WKWebView(), withCompletion: {
                                
                            })
                        }
                        
                        break
                        
                    case "startAudioSession":
                        
                        print("CuemeWebView startAudioSession request")
                        
                        DispatchQueue.main.async {
                            
                            var request = JSONObject()
                            
                            if source?.count ?? 0 > 0 {
                                request = JSONObject(jsonString: source)
                            }
                            
                            if (request != nil) {
                                
                                let category = request?.get("category") as? String
                                
                                if let category = category {
                                    
                                    var aCategory = AVAudioSession.Category.playAndRecord.rawValue
                                    
                                    switch category {
                                        
                                    case  "AVAudioSessionCategoryAmbient":
                                        
                                        aCategory = AVAudioSession.Category.ambient.rawValue
                                        break
                                        
                                    case "AVAudioSessionCategoryPlayAndRecord":
                                        
                                        aCategory = AVAudioSession.Category.playAndRecord.rawValue
                                        break
                                        
                                    case "AVAudioSessionCategoryPlayback":
                                        
                                        aCategory = AVAudioSession.Category.playback.rawValue
                                        break
                                        
                                    case "AVAudioSessionCategoryRecord":
                                        
                                        aCategory = AVAudioSession.Category.record.rawValue
                                        break
                                        
                                    case "AVAudioSessionCategorySoloAmbient" :
                                        
                                        aCategory = AVAudioSession.Category.soloAmbient.rawValue
                                        break
                                        
                                    default:
                                        break
                                        
                                    }
                                    
                                    let options =  request?.get("options") as? NSNumber
                                    
                                    let aOption = AVAudioSession.CategoryOptions(rawValue: (options != nil) ? UInt(options?.intValue ?? 0) : AVAudioSession.CategoryOptions.defaultToSpeaker.rawValue)
                                    
                                    print("EVAWebChatView : cuemeEventOccured : startAudioSession : Category=\(String(describing: aCategory)) options= \(aOption)")
                                    
                                    AudioUtil.beginAudioSession(aCategory, with: aOption, logger: self.mLogger_)
                                    
                                }
                            } else {
                                
                                print("EVAWebChatView : cuemeEventOccured : startAudioSession : DEFAULTS")
                                AudioUtil.beginAudioSession(AVAudioSession.Category.playAndRecord.rawValue, with: AVAudioSession.CategoryOptions.defaultToSpeaker, logger: self.mLogger_)
                            }
                        }
                        break
                        
                    case "stopAudioSession":
                        
                        print("CuemeWebView stopAudioSession request")
                        
                        var aOption: AVAudioSession.SetActiveOptions = []
                        
                        let request = JSONObject(jsonString: source)
                        
                        if request != nil {
                            if let options = request?.get("options") as? NSNumber {
                                aOption = AVAudioSession.SetActiveOptions(rawValue: options.uintValue)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            print("EVAWebChatView : cuemeEventOccured : stopAudioSession")
                            AudioUtil.endAudioSession(options: aOption, logger: self.mLogger_)
                        }
                        
                    case "cuememediaplayer_":
                        
                        if isCurrentWebviewMainWindow() == false {
                            
                            print("CuemeWebView : cueme mediaplayer events not supported : \(String(describing: eventName))")
                            return
                            
                        }
                        
                        var error: Error?
                        var mediatargetJson = JSONObject()
                        
                        if source != nil {
                            
                            mediatargetJson = JSONObject(jsonString: source)
                            
                            if (error != nil) {
                                
                                mLogger_?.error("Failed to parse target json sent to intialize CuemeMediaPlayer ")
                                mediatargetJson = nil
                            }
                        }
                        
                        error = nil
                        
                        var mediaDataJson = JSONObject()
                        if value != nil {
                            
                            mediaDataJson = JSONObject(jsonString: value)
                            if (error != nil) {
                                
                                mLogger_?.error("Failed to parse data json sent to intialize CuemeMediaPlayer ")
                                mediaDataJson = nil
                                
                            }
                        }
                        
                        if ((eventName?.hasPrefix("cuememediaplayer_internal_download")) == true) || ((eventName?.hasPrefix("cuememediaplayer_internal_getDownloadStatus")) == true) {
                            
                           _ = assetDownloadManager()?.handleCommand(eventName, target: mediatargetJson?.getData() as? NSDictionary, data: mediaDataJson?.getData() as? NSDictionary, completionBlock: { success,responseJson  in
                                
                            })
                            return
                        }
                        
                        print("CuemeWebView : handle cueme mediaplayer event : \(String(describing: eventName))")
                        if eventName == "cuememediaplayer_internal_init" {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                if self.videoPlayer == nil {
                                    let bvcResourceBundle = ApplicationUtil.getResourceBundle(withName: "EVAWebChatViewResources", using: type(of: self), logger: self.mLogger_)
                                    self.videoPlayer = (bvcResourceBundle?.loadNibNamed("VideoPlayerView", owner: nil, options: nil)?.last as? OSBVCVideoPlayerView)
                                    self.videoPlayer?.frame = CGRect(x: self.mContainerView_?.frame.origin.x ?? 0, y: self.mContainerView_?.frame.origin.y ?? 0, width: self.mContainerView_?.frame.size.width ?? 0, height: 0)
                                    self.videoPlayer?.resourceBundle = bvcResourceBundle
                                    self.videoPlayer?.delegate = self
                                    
                                    self.mContainerView_?.backgroundColor = UIColor.black
                                    self.mContainerView_?.insertSubview(self.videoPlayer!, aboveSubview: self.mWebView_ ?? WKWebView())
                                }
                                
                                let configError: Error? = nil
                                self.videoPlayer?.playerConfiguration(mediaDataJson, error: configError, parentFrame: self.mContainerView_?.frame, logger: self.mLogger_)
                                if let configError = configError {
                                    self.mLogger_?.error("CuemeMediaPlayer init : Failed to set configuration \(configError.localizedDescription)")
                                }
                                
                                self.videoPlayer?.layoutIfNeeded()
                                self.resetWebviewHeightToContainerHeight()
                                if let videoPlayer = self.videoPlayer, !videoPlayer.isHidden {
                                    self.reduceWebViewHeight(by: Int(videoPlayer.frame.size.height))
                                }
                                
                                self.raiseVideoPlayerResponse(eventName: eventName ?? "", status: true, target: mediatargetJson, data: nil)
                            }
                        } else {
                            DispatchQueue.main.async { [weak self] in
                                guard let self = self else { return }
                                if let videoPlayer = self.videoPlayer {
                                    if eventName == "cuememediaplayer_internal_show" {
                                        if videoPlayer.isHidden {
                                            videoPlayer.isHidden = false
                                            self.reduceWebViewHeight(by: Int(videoPlayer.frame.size.height))
                                        }
                                        self.raiseVideoPlayerResponse(eventName: eventName ?? "", status: true, target: mediatargetJson, data: nil)
                                    } else if eventName == "cuememediaplayer_internal_hide" {
                                        if !videoPlayer.isHidden {
                                            videoPlayer.isHidden = true
                                            self.resetWebviewHeightToContainerHeight()
                                        }
                                        self.raiseVideoPlayerResponse(eventName: eventName ?? "", status: true, target: mediatargetJson, data: nil)
                                    } else {
                                        _ = videoPlayer.handleCommand(eventName, mediatargetJson, mediaDataJson) { isSuccess, responseJson in
                                        self.raiseVideoPlayerResponse(eventName: eventName ?? "", status: isSuccess, target: mediatargetJson, data: responseJson)
                                        }
                                    }
                                } else {
                                    print("VideoPlayer is only supported on main window and video player init must be called before calling any other methods")
                                }
                            }
                        }
                        break
                    
                    default :
                        break
                        
                    }
                    
                    DispatchQueue.global(qos: .default).async { [self] in
                        
                        switch eventName {
                            
                        case "goBack":
                            
                            let webviewId = source
                            print("goBack: source: \(String(describing: source))")
                            
                            if mViewId_?.count ?? 0 > 0 {
                                
                                print("Closing window: \(String(describing: source))")
                                mComponent_?.closeChildWindow(webviewId, nil)
                                
                            } else {
                                
                                print("Exiting current application")
                                mComponent_?.exitApplication()
                            }
                            
                            break
                            
                        case "closeWindow":
                            
                            let webviewId = source
                            if webviewId != nil {
                                print("EVAWebChatView: closeWindow : \(String(describing: webviewId))")
                                mComponent_?.closeChildWindow(webviewId, nil)
                            } else {
                                mLogger_?.warn("EVAWebChatView: Cannot close main Window.")
                            }
                            
                            break
                            
                        case "openWindow":
                            
                            let webviewId = source
                            if webviewId != nil {
                               
                                print("EVAWebChatView: openWindow : \(String(describing: webviewId))")
                                mComponent_?.openChildWindow(webviewId, url: value, target: nil)
                                
                            } else {
                                
                                mLogger_?.warn("EVAWebChatView: Cannot openWindow main Window.")
                           
                            }
                            
                            break
                            
                        case "showWindow":
                            
                            let webviewId = source
                            mComponent_?.showWindow(viewId: webviewId)
                            break
                            
                        case "exitApplication":
                            
                            print("Exiting application request")
                            mComponent_?.exitApplication()
                            break
                            
                        default:
                            
                            break
                      
                    }
        
                }

            } else {
               print("body = \(body)")
            }*/
        }
    }
}

//MARK: - Custom Methods -
extension EVAWebChatView {
    
    //MARK: isApplicationErrorPage
    /// Checks if the given URL is an application error page.
    /// - Parameter url: String
    /// - Returns: Bool
    func isApplicationErrorPage(_ url: String?) -> Bool {
        
        if url?.hasPrefix(ErrorPageUrl) ?? true {
           print("Ignore application error page events")
            return true
        }
        return false
        
    }
    
    //MARK: errorPageLoadComplete
    /// Handles the completion of loading the error page in the web view
    /// - Parameter webView: WKWebView
    func errorPageLoadComplete(_ webView: WKWebView?) {
        
        print("BrowserViewComponnent : errorPageLoadComplete :  webViewId: \(mViewId_ ?? "")")
        
//        let cuemeData = JSONObject()
        
//        cuemeData?.put("errorObj", value: mLoadError_)
        
        if (mViewId_ != nil) {
            
//            cuemeData?.put("viewId", value: mViewId_)
//            let setCuemeData = String(format: "_cuemeapp.setCuemeData(%@)", cuemeData?.toString() ?? "")
//            
//            print("Executing : \(setCuemeData)")
//            
//            webView?.evaluateJavaScript(setCuemeData, completionHandler: { result,error in
//                
//                print("firing cueme_ready")
//                //self.fireCuemeReady(completionHandler: nil)
//                
//            })
        }
    }
}

//MARK: - Custom Methods -
extension EVAWebChatView {
    
    class func getMimeType(_ urlString: String?) -> String? {
        var mimeType: String?
        
        if urlString?.lowercased().hasSuffix(".jpg") ?? false {
            mimeType = "image/jpeg"
        } else if urlString?.lowercased().hasSuffix(".png") ?? false {
            mimeType = "image/png"
        } else if urlString?.lowercased().hasSuffix(".css") ?? false {
            mimeType = "text/css"
        } else if urlString?.lowercased().hasSuffix(".htm") ?? false || urlString?.lowercased().hasSuffix(".html") ?? false {
            mimeType = "text/html"
        } else if urlString?.lowercased().hasSuffix(".js") ?? false {
            mimeType = "text/javascript"
        } else if urlString?.lowercased().hasSuffix(".pdf") ?? false {
            mimeType = "application/pdf"
        } else {
            var type = ""
            let url = NSURL(fileURLWithPath: urlString ?? "")
            let pathExtension = url.pathExtension

            if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
                if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                    type = mimetype as String
                }
            }
            if type.isEmpty {
                mimeType = "application/octet-stream"
            } else {
                mimeType = type
            }
        }
        return mimeType
    }
}
