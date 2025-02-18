//
//  EVAWebChat.swift
//  EVAWebChat
//
//  Created by Raghavendra on 16/04/24.
//

import Foundation
import UIKit
import WebChatPod

public protocol EVAWebChatCameraDelegate {
    
    func takePictureSuccess(image:UIImage)
    func takePictureFail()
}

public protocol EVAWebChatCalendarDelegate {
    
    func createCalendarEventSuccess(_ response:[String:Any])
    func createCalendarEventFail(_ errorResponse:[String:Any])
    
    func listCalendarEventSuccess(_ response:[String:Any])
    func listCalendarEventFail(_ errorResponse:[String:Any])
    
    func deleteCalendarEventSuccess(_ response:[String:Any])
    func deleteCalendarEventFail(_ errorResponse:[String:Any])
}

public protocol EVAWebChatContactDelegate {
    
    func addContactSuccess(_ response:[String:Any])
    func addContactFail(_ errorResponse:[String:Any])
    
    func getContactsSuccess(_ response:[String:Any])
    func getContactsFail(_ errorResponse:[String:Any])
    
    func pickContactSuccess(_ response:[String:Any])
    func pickContactFail(_ errorResponse:[String:Any])
}

public protocol EVAChatBotDelegate {
    
    func showChatBotSuccess(_ response:[String:Any])
    func showChatBotFail(_ errorResponse:[String:Any])
    
    func closeChatBotSuccess(_ response:[String:Any])
    func closeChatBotFail(_ errorResponse:[String:Any])
    
    func minimizeChatBotSuccess(_ response:[String:Any])
    func minimizeChatBotFail(_ errorResponse:[String:Any])
}

/// Reference to `WebChat.default` for quick bootstrapping; Alamofire style!
public let evaWebChat = WebChat.default

public class WebChat {
    /// Shared singleton instance.
    
//    var subscriptionKey = ""
    public static let `default` = WebChat()
    public var navigationController:UINavigationController?
    public var cameraDelegate:EVAWebChatCameraDelegate?
    public var calendarDelegate:EVAWebChatCalendarDelegate?
    public var contactDelegate:EVAWebChatContactDelegate?
    public var evaChatBotDelegate:EVAChatBotDelegate?
    private var evaCalendarHandler: EVAWebChatCalendarHandler? // Optional instance of EVACalendarHandler class.
    private var evaContactsHandler: EVAWebChatContactsHandler?  // Optional instance of EVAWebChatContactsHandler class.
    private var evaChatBotView:EVAWebChatView?
    var initialConfiguration: [String:Any] = [:]

    var EVAVISION_DEFAULT_THRESHOLD_BLUR = 80          // Integer representing default threshold for detecting image blur.
    var EVAVISION_DEFAULT_THRESHOLD_BRIGHTNESS = 128   // Integer representing default threshold for detecting image brightness.
    var intialURLLink = "resource://evawebchat/index.html"
    
    
    
    // Prevent  developers from creating their own instances by making the initializer `private`.
    init() {}
    
    //MARK: initializeSDK
    /// Initializes the SDK with the provided configuration and navigation controller.
    /// - Parameters:
    ///   - config: [String:Any]
    ///   - navigationController: UINavigationController
    public func initializeSDK(_ config:[String:Any], _ navigationController:UINavigationController?) {
        
//        if let subscriptionKey = config["key"] as? String {
//            self.subscriptionKey = subscriptionKey
//        }
//        
        self.initialConfiguration = config
        self.navigationController = navigationController
        
        // Register to receive notifications for successful contact picker events.
        NotificationCenter.default.addObserver(self, selector: #selector(self.contactPickerSucess(notification:)), name: Notification.Name("ContactPickerSucess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.contactPickerDidCancel(notification:)), name: Notification.Name("ContactPickerDidCancel"), object: nil)
    }
}

// MARK: - Public developer APIs -
public extension WebChat {
    
    //MARK: - WebView Methods -
    
    //MARK: showChatBotView
    /// Displays the chatbot view within the specified superView.
    /// - Parameter superView: UIView
    func showChatBotView(_ superView:UIView) {
        
        // Get the current view controller from the navigation stack or presented view controller.
        var currentViewController = self.navigationController?.topViewController
        if currentViewController == nil {
            currentViewController = self.navigationController?.presentedViewController
        }
        if(evaChatBotView == nil) {
            
            // If not instantiated, create a new instance of the chatbot view.
            let className = String(describing: EVAWebChatView.self)
            evaChatBotView = EVAWebChatView.initWith(frame: superView.bounds)
            if let evaChatBotView = evaChatBotView {
                //let indexFilePath = bundle.path(forResource: "index", ofType: "html")
                // Set the initial URL link for the chatbot view.
                evaChatBotView.webPageURL = intialURLLink//indexFilePath ?? ""
                // Set initial configuration parameters.
                evaChatBotView.initialConfiguration = self.initialConfiguration
                
                // Set the delegate for handling chatbot events.
                evaChatBotView.evaWebChatBotDelegate = self
                // Set the source view controller.
                evaChatBotView.sourceVC = currentViewController
                // Set the superView.
                evaChatBotView.superView = superView
                // Load the web view content.
                evaChatBotView.loadWebView()
                // Add the chatbot view to the superView.
                superView.addSubview(evaChatBotView)
                // Bring the chatbot view to the front.
                superView.bringSubviewToFront(evaChatBotView)
                
            }  else {
                fatalError("Failed to load nib for view \(className).")
            }
        } else {
            // If the chatbot view is already instantiated, update its properties and display it.
            evaChatBotView?.initialConfiguration = self.initialConfiguration
            evaChatBotView?.evaWebChatBotDelegate = self
            evaChatBotView?.sourceVC = currentViewController
            evaChatBotView?.superView = superView
            evaChatBotView?.showChatBotView()
        }
    }
    
    //MARK: closeChatBotView
    /// Closes the chatbot view within the specified superView.
    /// - Parameter superView: UIView
    func closeChatBotView(_ superView:UIView) {
        
        // Attempt to find the chatbot view within the subviews of the superView.
        if let evaChatBotView = superView.subviews.first(where: {$0 == evaChatBotView}) as? EVAWebChatView {
           // do something with evaChatBotView
            // If the chatbot view is found, perform actions related to closing it.
            evaChatBotView.closeChatBotView()
            
        } else {
           // item could not be found
            print("Unable to close Chat Bot View")
        }
    }
    
    func updateScripts(_ params:[String:Any]) {
        if (evaChatBotView != nil) {
            
        }
    }
}

//MARK: - Camera Methods -
public extension WebChat {
    
    //MARK: takePicture
    /// Initiates the process of taking a picture using the camera.
    /// - Parameter params: [String:Any]
    func takePicture(_ params:[String:Any]) {
        
        // Access the shared camera handler instance.
        let cameraHandler = EVAWebChatCameraHandler.sharedInstance
        cameraHandler.delegate = self
        
        // Get the current view controller to present the camera interface.
        var currentViewController = self.navigationController?.topViewController
        if currentViewController == nil {
            currentViewController = self.navigationController?.presentedViewController
        }
        if let currentViewController = currentViewController {
            cameraHandler.launchCameraUI(viewcontroller: currentViewController)
        } else {
            //Implement fail callback
            if(cameraDelegate != nil) {
                cameraDelegate?.takePictureFail()
            }
        }
    }
}

//MARK: - Vision Methods -
public extension WebChat {
    
    //MARK: checkBrightness
    /// Checks the brightness of the image passed.
    /// - Parameter image: UIImage
    /// - Returns: [String: Any]
    func checkBrightness(_ image:UIImage) -> [String:Any] {
        print("WebChat : checkBrightness : begin")
        var brightnessData:[String:Any] = [:]
        let startTime = Date()
        //Object of OSEImageQualityDetector class.
//        let imageQualityDetector = OSEImageQualityDetector()
        
        // Checks brightness score of the image.
        let brightnessScore = 2 //imageQualityDetector.detectImageBrightness(image)
        if brightnessScore > 0 {
            brightnessData["score"] = brightnessScore
            if brightnessScore < EVAVISION_DEFAULT_THRESHOLD_BRIGHTNESS {
                brightnessData["lowlight"] = true
                brightnessData["lowLight"] = true
            } else {
                brightnessData["lowlight"] = false
                brightnessData["lowLight"] = false
            }
        }

        print("WebChat : checkBrightness : end timetaken = \(Date().timeIntervalSince(startTime))")
        return brightnessData
    }
    
    //MARK: checkForBlur
    /// Checks the blurness of the image passed.
    /// - Parameter image: UIImage
    /// - Returns: [String : Any]
    func checkForBlur(_ image:UIImage) -> [String:Any] {
        print("WebChat : checkForBlur : begin")
        let startTime = Date()
        var blurData:[String:Any] = [:]
        //Object of OSEImageQualityDetector class.
       // let imageQualityDetector = OSEImageQualityDetector()
        
        // Checks blurscore of the image.
        let blurScore = 2 //imageQualityDetector.detectImageBlur(usingOpenCVFilter2D: image)
        if blurScore > 0 {
            blurData["score"] = blurScore
            blurData["focusScore"] = blurScore
            if blurScore < EVAVISION_DEFAULT_THRESHOLD_BLUR {
                blurData["blur"] = true
            } else {
                blurData["blur"] = false
            }

            let laplacianScore = 2.00 //imageQualityDetector.detectImageBlur(usingOpenCVLaplacian: image)
            blurData["laplacianScore"] = laplacianScore
        }

        print("WebChat : checkForBlur : end : timetaken = \(Date().timeIntervalSince(startTime))")
        return blurData
    }
}


//MARK: - Calendar Methods -
public extension WebChat {
    
    // MARK: initializeOSECalendarHandler
    /// It gets initialize thw event UI
    func initializeOSECalendarHandler() {
        if self.evaCalendarHandler == nil {
            let parentViewController = navigationController?.presentedViewController ?? navigationController?.topViewController
            self.evaCalendarHandler = EVAWebChatCalendarHandler(viewController: parentViewController)
        }
    }
        
    //MARK: createCalendarEvent
    /// Creates a event calendar
    /// - Parameter params: [String: Any]
    func createCalendarEvent(_ params:[String:Any]) {
        
        print("WebChat : createCalendarEvent")
        
        if params.isEmpty {
            print("EVACalendarComponent : createEvent : missing input data")
            var errorData:[String:Any] = [:]
            errorData["error_message"] = "missing input data"
            if(calendarDelegate != nil) {
                calendarDelegate?.createCalendarEventFail(errorData)
            }
        } else {
            
            var resultJSON:[String:Any] = [:]
            resultJSON["inputRequest"] = params
            self.initializeOSECalendarHandler()
            //Checks for the authorization permissions.
            if ((self.evaCalendarHandler?.hasCalendarPermissions()) != nil) {
                evaCalendarHandler?.requestAuthorization() { [weak self] result, message in
                    if result {
                        self?.evaCalendarHandler?.initializeCalendar()
                        let launchUI:Bool = params["launchUI"] as? Bool ?? false
                        if launchUI {
                            self?.evaCalendarHandler?.createEventUsingLaunchUI(params, {[weak self] status,message in
                                if status {
                                    resultJSON["eventId"] = message
                                    if(self?.calendarDelegate != nil) {
                                        self?.calendarDelegate?.createCalendarEventSuccess(resultJSON)
                                    }
                                } else {
                                    resultJSON["error_message"] = message
                                    if(self?.calendarDelegate != nil) {
                                        self?.calendarDelegate?.createCalendarEventFail(resultJSON)
                                    }
                                }
                            })
                        } else {
                            let eventId = self?.evaCalendarHandler?.createEvent(params)
                            if eventId != nil {
                                resultJSON["eventId"] = eventId
                                if(self?.calendarDelegate != nil) {
                                    self?.calendarDelegate?.createCalendarEventSuccess(resultJSON)
                                }
                            } else {
                                resultJSON["error_message"] = "Unable to create event"
                                if(self?.calendarDelegate != nil) {
                                    self?.calendarDelegate?.createCalendarEventFail(resultJSON)
                                }
                            }
                        }
                    } else {
                        resultJSON["error_message"] = message
                        if(self?.calendarDelegate != nil) {
                            self?.calendarDelegate?.createCalendarEventFail(resultJSON)
                        }
                    }
                }
            } else {
                let eventId = self.evaCalendarHandler?.createEvent(params)
                if eventId != nil {
                    resultJSON["eventId"] = eventId
                    if(calendarDelegate != nil) {
                        calendarDelegate?.createCalendarEventSuccess(resultJSON)
                    }
                }else{
                    resultJSON["error_message"] = "Unable to create event"
                    if(calendarDelegate != nil) {
                        calendarDelegate?.createCalendarEventFail(resultJSON)
                    }
                }
            }
        }
    }
    
    //MARK: listCalendarEvents
    /// List all the events from Calendar
    /// - Parameter params: [String:Any]
    func listCalendarEvents(_ params:[String:Any]) {
        print("WebChat : listCalendarEvents")
        if params.isEmpty {
            print("EVACalendarComponent : listCalendarEvents : missing input data")
            var errorData:[String:Any] = [:]
            errorData["error_message"] = "missing input data"
            if(calendarDelegate != nil) {
                calendarDelegate?.listCalendarEventFail(errorData)
            }
        } else {
            
            var resultJSON:[String:Any] = [:]
            resultJSON["inputRequest"] = params
            self.initializeOSECalendarHandler()
            
            //Checks for the authorization permissions.
            if ((self.evaCalendarHandler?.hasCalendarPermissions()) != nil) {
                evaCalendarHandler?.requestAuthorization() { [weak self] result, message in
                        if result {
                            self?.evaCalendarHandler?.initializeCalendar()
                            let arrayOfEvents = self?.evaCalendarHandler?.listEvents(params)
                            resultJSON["listOfEvents"] = arrayOfEvents
                            if(self?.calendarDelegate != nil) {
                                self?.calendarDelegate?.listCalendarEventSuccess(resultJSON)
                            }
                        } else {
                            resultJSON["error_message"] = message
                            if(self?.calendarDelegate != nil) {
                                self?.calendarDelegate?.listCalendarEventFail(resultJSON)
                            }
                        }
                    }
            } else {
                let arrayOfEvents = evaCalendarHandler?.listEvents(params)
                resultJSON["listOfEvents"] = arrayOfEvents
                if(self.calendarDelegate != nil) {
                    self.calendarDelegate?.listCalendarEventSuccess(resultJSON)
                }
            }
        }
    }
    
    //MARK: deleteEvents
    /// Delets the events from the calendar
    /// - Parameter params: [String:Any]
    func deleteCalendarEvents(_ params:[String:Any]) {
        print("WebChat : deleteCalendarEvents")
        if params.isEmpty {
            print("WebChat : deleteCalendarEvents : missing input data")
            var errorData:[String:Any] = [:]
            errorData["error_message"] = "missing input data"
            if(calendarDelegate != nil) {
                calendarDelegate?.listCalendarEventFail(errorData)
            }
        } else {
            
            var resultJSON:[String:Any] = [:]
            resultJSON["inputRequest"] = params
            self.initializeOSECalendarHandler()
            
            //Checks for the authorization permissions.
            if((self.evaCalendarHandler?.hasCalendarPermissions()) != nil) {
                evaCalendarHandler?.requestAuthorization() { [weak self] result, message in
                        if result {
                            self?.evaCalendarHandler?.initializeCalendar()
                            let deleteResult = self?.evaCalendarHandler?.deleteEvent(params)
                            if deleteResult == true {
                                resultJSON["message"] = "Success"
                                if(self?.calendarDelegate != nil) {
                                    self?.calendarDelegate?.deleteCalendarEventSuccess(resultJSON)
                                }
                            } else {
                                resultJSON["error_message"] = "Unable to delete event"
                                if(self?.calendarDelegate != nil) {
                                    self?.calendarDelegate?.deleteCalendarEventFail(resultJSON)
                                }
                            }
                        } else {
                            resultJSON["error_message"] = message
                            if(self?.calendarDelegate != nil) {
                                self?.calendarDelegate?.deleteCalendarEventFail(resultJSON)
                            }
                        }
                    }
            } else {
                let deleteResult = evaCalendarHandler?.deleteEvent(params)
                if deleteResult == true {
                    resultJSON["message"] = "Success"
                    if(self.calendarDelegate != nil) {
                        self.calendarDelegate?.deleteCalendarEventSuccess(resultJSON)
                    }
                } else {
                    resultJSON["error_message"] = "Unable to delete event"
                    if(self.calendarDelegate != nil) {
                        self.calendarDelegate?.deleteCalendarEventFail(resultJSON)
                    }
                }
            }
        }
    }
}

//MARK: - Contacts Methods -
public extension WebChat {
    //MARK: initializeOSEContactHandler
    /// It intializes the UI that need to be launched by Component
    func initializeOSEContactHandler() {
        if evaContactsHandler == nil {
            let parentViewController = self.navigationController?.presentedViewController ?? self.navigationController?.topViewController
            evaContactsHandler = EVAWebChatContactsHandler(viewController: parentViewController)
        }
    }
        
    // MARK: addNewContact
    /// Method to Add new contact to device
    /// - Parameter event: IMEvents
    func addContact(_ params:[String:Any]) {
        print("WebChat : addContact")
        initializeOSEContactHandler()
        
        if params.isEmpty {
            print("WebChat : addNewContact : missing input data")
            if let errorData = EVAWebChatContactsError.constructEventError(with: .MissingInputData) {
                if(contactDelegate != nil) {
                    contactDelegate?.addContactFail(errorData)
                }
            }
        } else {
            evaContactsHandler?.checkContactsPermission({ [weak self] permissionWasGranted in
                if permissionWasGranted {
                    
                    self?.evaContactsHandler?.addNewContact(params) { updateContactStatus, error in
                        if updateContactStatus {
                            //Success to add new contact
                            print("WebChat : addContact : Successfully added new contact")
                            var response:[String:Any] = [:]
                            response["message"] = "Successfully added new contact"
                            response["request"] = params
                            if(self?.contactDelegate != nil) {
                                self?.contactDelegate?.addContactSuccess(response)
                            }
                        } else {
                            //Fail to add new contact
                            print("WebChat : addContact : Failed to add new contact")
                            if let errorData = EVAWebChatContactsError.constructEventError(with: .FailedToAddNewContact) {
                                if(self?.contactDelegate != nil) {
                                    self?.contactDelegate?.addContactFail(errorData)
                                }
                            }
                        }
                    }
                } else {
                    // raise permission error response
                    print("WebChat : addContact : User denied permissions")
                    if let errorData = EVAWebChatContactsError.constructPermissionError(with: .PermissionDenied) {
                        if(self?.contactDelegate != nil) {
                            self?.contactDelegate?.addContactFail(errorData)
                        }
                    }
                }
            })
        }
        
    }
    
    // MARK: getAllContacts
    /// Method to Get list of available contacts from device
    func getContacts() {
        print("EVContactComponent : getContacts")
        initializeOSEContactHandler()
        evaContactsHandler?.checkContactsPermission({ [weak self] permissionWasGranted in
            if permissionWasGranted {
                self?.evaContactsHandler?.fetchingContacts({ [weak self] contactList, error in
                    if error == nil {
                        //Will get an Array of Contact list
                        var response:[String:Any] = [:]
                        response["contacts"] = contactList
                        response["message"] = "Get Contacts successful..."
                        if(self?.contactDelegate != nil) {
                            self?.contactDelegate?.getContactsSuccess(response)
                        }
                    } else {
                        
                        //Fail to add new contact
                        print("WebChat : getContacts : Failed to read contacts")
                        if let errorData = EVAWebChatContactsError.constructEventError(with: .ErrorWhileReadingContact) {
                            if(self?.contactDelegate != nil) {
                                self?.contactDelegate?.getContactsFail(errorData)
                            }
                        }
                    }
                })
            } else {
                // raise permission error response
                print("WebChat : getContacts : User denied permissions")
                if let errorData = EVAWebChatContactsError.constructPermissionError(with: .PermissionDenied) {
                    if(self?.contactDelegate != nil) {
                        self?.contactDelegate?.getContactsFail(errorData)
                    }
                }
            }
        })
        
    }
    
    
    // MARK: pickContact
    ///  Pick a specific contatcs from contacts application
    func pickContact() {
        print("WebChat : pickContact")
        initializeOSEContactHandler()
        evaContactsHandler?.checkContactsPermission({ [weak self] permissionWasGranted in
            if permissionWasGranted {
                self?.evaContactsHandler?.pickContact()
            } else {
                // raise permission error response
                print("WebChat : pickContact : User denied permissions")
                if let errorData = EVAWebChatContactsError.constructPermissionError(with: .PermissionDenied) {
                    if(self?.contactDelegate != nil) {
                        self?.contactDelegate?.pickContactFail(errorData)
                    }
                }
            }
        })
        
    }
    
    // MARK: Pick Events Notification Methods
    
    //MARK: contactPickerDidCancel
    /// Called when the user cancels the contact picking process.
    /// - Parameter notification: Notification
    @objc func contactPickerDidCancel(notification: Notification) {
        print("WebChat : pickContact : Contact is not selected")
        if let errorData = EVAWebChatContactsError.constructEventError(with: .PickContactNotSelected) {
            if(self.contactDelegate != nil) {
                self.contactDelegate?.pickContactFail(errorData)
            }
        }
    }
    
    //MARK: contactPickerSucess
    /// Called when the user pciks successfully the contact.
    /// - Parameter notification: Notification
    @objc func contactPickerSucess(notification: Notification) {
        print(notification.object ?? "") //myObject
        if let contactResponse = notification.object as? [String:Any] {
            //Success to delete particular contact detail
            print("WebChat : pickContact : Successfully pick particular contact details : \(String(describing: contactResponse))")
            
            // Check if the contact delegate is set and call the appropriate method to handle the success.
            if(self.contactDelegate != nil) {
                self.contactDelegate?.pickContactSuccess(contactResponse)
            }
            
        } else {
            //Fail to pick particular contact detail
            print("WebChat : pickContact : Failed to pick particular contact details")
            if let errorData = EVAWebChatContactsError.constructEventError(with: .UnableToPickParticularContactDetail) {
                if(self.contactDelegate != nil) {
                    self.contactDelegate?.pickContactFail(errorData)
                }
            }
        }
    }
}

//MARK: - Camera Handler Delegate Methods -
extension WebChat:EVAWebChatCameraHandlerDelegate {
    
    //MARK: capturedImageSuccess
    /// Tells the delegate that image capture is Success
    /// - Parameter image: UIImage.
    func capturedImageSuccess(image: UIImage) {
//        let imageData = image.pngData()
//        let imageBase64String = imageData?.base64EncodedString(options: .init(rawValue: 0)) ?? ""
        
        //Send back captured image to native application
        if(cameraDelegate != nil) {
            cameraDelegate?.takePictureSuccess(image: image)
        }
    }
    
    //MARK: capturedImageFail
    /// Tells the delegate that image capture is failed.
    func capturedImageFail() {
        //Implement fail callback
        if(cameraDelegate != nil) {
            cameraDelegate?.takePictureFail()
        }
    }
}

//MARK: - extension to EVAWebChatBotDelegate -

extension WebChat:EVAWebChatBotDelegate {
    
    //MARK: showWebChatBotSuccess
    /// Tells the delegate that chat bot is viewed successfully.
    /// - Parameter response: [String : Any]
    public func showWebChatBotSuccess(_ response: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.showChatBotSuccess(response)
        }
    }
    
    //MARK: showWebChatBotFail
    /// Tells the delegate that chat bot is viewed failed.
    /// - Parameter response: [String : Any]
    public func showWebChatBotFail(_ errorResponse: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.showChatBotFail(errorResponse)
        }
    }
    
    //MARK: closeWebChatBotSuccess
    /// Tells the delegate that chat bot is closed successfully..
    /// - Parameter response: [String : Any]
    public func closeWebChatBotSuccess(_ response: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.closeChatBotSuccess(response)
        }
    }
    
    //MARK: closeWebChatBotFail
    /// Tells the delegate that chat bot is closed failed..
    /// - Parameter response: [String : Any]
    public func closeWebChatBotFail(_ errorResponse: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.closeChatBotFail(errorResponse)
        }
    }
    
    //MARK: minimizeWebChatBotSuccess
    /// Tells the delegate that minimizing of chat box is success.
    /// - Parameter response: [String : Any]
    public func minimizeWebChatBotSuccess(_ response: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.minimizeChatBotSuccess(response)
        }
    }
    
    //MARK: minimizeWebChatBotFail
    /// Tells the delegate that minimizing of chat box is Failed.
    /// - Parameter response: [String : Any]
    public func minimizeWebChatBotFail(_ errorResponse: [String : Any]) {
        if(evaChatBotDelegate != nil) {
            evaChatBotDelegate?.minimizeChatBotFail(errorResponse)
        }
    }
}

