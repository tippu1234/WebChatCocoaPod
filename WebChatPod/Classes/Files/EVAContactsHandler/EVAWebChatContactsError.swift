//
//  EVAWebChatContactsError.swift
//  EVAWebChatContactsError
//
//  Created by Bharathan V on 29/08/22.
//

import Foundation

public enum EVAWebChatContactsErrorCode {

    //Permission errors
    public enum Permission:Int {
        
        /// Indicates permission usage string is missing in info.plist
        case PermissionUsageDescriptionMissing = 8887
        /// Indicates user denied permission for a required resource.
        case PermissionDenied = 8888
        /// This error is raised when any event has a invalid target
        case InvalidEventTarget = 9000
        /// This error is raised when any event has a invalid data
        case InvalidEventData = 9001
        /// Unhandled errors
        case Unsupported = 9002
        /// Unhandled errors
        case Unknown = 9999
    }
    
    ///PickContact errors
    public enum Events:Int {
        ///Cancels pickup contact pop-up by without selecting any contact
        case PickContactNotSelected = 1001
        ///Fail to pick particular contact detail
        case UnableToPickParticularContactDetail = 1002
        ///Error while reading contact error
        case ErrorWhileReadingContact = 1000
        ///Fail to add new contact
        case FailedToAddNewContact = 1003
        ///Fail to update contact
        case FailedToUpdateContact = 1004
        ///Fail to update contact
        case FailedToDeleteContact = 1005
        ///unkown error
        case Unknown = 999
        /// Indicates user denied permission for a required resource.
        case MissingInputData = 998
    }
}

/// Indicates permission usage string is missing in info.plist
/// Indicates user denied permission for a required resource.
/// This error is raised when any event has a invalid target
/// This error is raised when any event has a invalid data
/// Unhandled errors
/// Unhandled errors
let KeyErrorCode = "errorCode"
let KeyErrorMessage = "errorMessage"
let KeyErrorDescription = "errorDescription"
let KeyErrorDomain = "errorDomain"

    
// MARK: Construct Error
@objc(EVAWebChatContactsError)
public class EVAWebChatContactsError: NSObject {
    
    let EVAWebChatContactsErrorDomain:NSErrorDomain = NSErrorDomain(string:"com.openstream.eva.contacts")
    private var errorObj: [String:Any]?
    
    private let EVAWebChatContactsErrorList:[NSNumber : [String:Any]] = [
            NSNumber(value: EVAWebChatContactsErrorCode.Permission.PermissionUsageDescriptionMissing.rawValue): [
            KeyErrorCode: NSNumber(value:  EVAWebChatContactsErrorCode.Permission.PermissionUsageDescriptionMissing.rawValue),
            KeyErrorMessage: "permission_usage_description_missing",
            KeyErrorDescription: "Usage description missing in Info.plist file"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Permission.PermissionDenied.rawValue): [
            KeyErrorCode: NSNumber(value: EVAWebChatContactsErrorCode.Permission.PermissionDenied.rawValue),
            KeyErrorMessage: "permission_error",
            KeyErrorDescription: "User denied permissions"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Permission.InvalidEventTarget.rawValue): [
            KeyErrorCode: NSNumber(value: EVAWebChatContactsErrorCode.Permission.InvalidEventTarget.rawValue),
            KeyErrorMessage: "invalid_event_target",
            KeyErrorDescription: "Invalid event target"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Permission.InvalidEventData.rawValue): [
            KeyErrorCode: NSNumber(value: EVAWebChatContactsErrorCode.Permission.InvalidEventData.rawValue),
            KeyErrorMessage: "invalid_event_data",
            KeyErrorDescription: "Invalid event data."
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Permission.Unsupported.rawValue): [
            KeyErrorCode: NSNumber(value: EVAWebChatContactsErrorCode.Permission.Unsupported.rawValue),
            KeyErrorMessage: "unsupported",
            KeyErrorDescription: "Unsupported operation,"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Permission.Unknown.rawValue): [
            KeyErrorCode: NSNumber(value: EVAWebChatContactsErrorCode.Permission.Unknown.rawValue),
            KeyErrorMessage: "unknown_error",
            KeyErrorDescription: "unknown error."
        ],
            
        //Events Error
        NSNumber(value: EVAWebChatContactsErrorCode.Events.PickContactNotSelected.rawValue): [
                KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.PickContactNotSelected.rawValue))",
            KeyErrorMessage: "contact_not_selected",
            KeyErrorDescription: "Contact is not selected"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.UnableToPickParticularContactDetail.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.UnableToPickParticularContactDetail.rawValue))",
            KeyErrorMessage: "unable_to_get_contact_details",
            KeyErrorDescription: "Error while reading contact....Unable to get particular contact details"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.ErrorWhileReadingContact.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.ErrorWhileReadingContact.rawValue))",
            KeyErrorMessage: "error_reading_contact",
            KeyErrorDescription: "Error while reading contact"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.MissingInputData.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.MissingInputData.rawValue))",
            KeyErrorMessage: "missing_input_data",
            KeyErrorDescription: "Missing Input Data"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToAddNewContact.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToAddNewContact.rawValue))",
            KeyErrorMessage: "failed_to_add_new_contact",
            KeyErrorDescription: "Failed to add new contact"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToUpdateContact.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToUpdateContact.rawValue))",
            KeyErrorMessage: "failed_to_update_contact",
            KeyErrorDescription: "Failed to update contact"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToDeleteContact.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.FailedToDeleteContact.rawValue))",
            KeyErrorMessage: "failed_to_delete_contact",
            KeyErrorDescription: "Failed to delete particular contact details"
        ],
        NSNumber(value: EVAWebChatContactsErrorCode.Events.Unknown.rawValue): [
            KeyErrorCode: "contact-\(NSNumber(value: EVAWebChatContactsErrorCode.Events.UnableToPickParticularContactDetail.rawValue))",
            KeyErrorMessage: "unknown_error",
            KeyErrorDescription: "unknown error."
        ]
    ]
    //MARK: Initialization of Permission Error Code
    /// Initialization of Permission Error Code
    /// - Parameters:
    ///   - permissionErrorCode: EVAWebChatContactsErrorCode.Permission
    ///   - errorMsg: String
    ///   - errorDescription: String
    init(permissionErrorCode: EVAWebChatContactsErrorCode.Permission,
                    errorMsg: String?,
            errorDescription: String?) {
        
        // TODO: [Swiftify] ensure that the code below is executed only once (`dispatch_once()` is deprecated)
            
        super.init()
        
        var errorObj = EVAWebChatContactsErrorList[NSNumber(value: permissionErrorCode.rawValue)]
        if errorObj == nil {
            errorObj = EVAWebChatContactsErrorList[NSNumber(value: EVAWebChatContactsErrorCode.Permission.Unknown.rawValue)]
        }
        self.errorObj = errorObj
        
        if let errorDescription = errorDescription {
            self.errorObj?[KeyErrorDescription] = errorDescription
        }
                
        if let errorMsg = errorMsg {
            self.errorObj?[KeyErrorMessage] = errorMsg
        }
        
        self.errorObj?[KeyErrorDomain] = EVAWebChatContactsErrorDomain
    }
    
    //MARK: Initialization of Events Error Code
    /// Initialization of Events Error Code
    /// - Parameters:
    ///   - permissionErrorCode: EVAWebChatContactsErrorCode.Events
    ///   - errorMsg: String
    ///   - errorDescription: String
    init(eventsErrorCode: EVAWebChatContactsErrorCode.Events,
                errorMsg: String?,
        errorDescription: String?) {
        
        // TODO: [Swiftify] ensure that the code below is executed only once (`dispatch_once()` is deprecated)
            
        super.init()
        
        var errorObj = EVAWebChatContactsErrorList[NSNumber(value: eventsErrorCode.rawValue)]
        if errorObj == nil {
            errorObj = EVAWebChatContactsErrorList[NSNumber(value: EVAWebChatContactsErrorCode.Events.Unknown.rawValue)]
        }
        self.errorObj = errorObj
        
        if let errorDescription = errorDescription {
            self.errorObj?[KeyErrorDescription] = errorDescription
        }
                
        if let errorMsg = errorMsg {
            self.errorObj?[KeyErrorMessage] = errorMsg
        }
        
        self.errorObj?[KeyErrorDomain] = EVAWebChatContactsErrorDomain
    }
    
    //MARK: constructPermissionError
    /// Permission Errors
    /// - Parameter errorCode: EVAWebChatContactsErrorCode.Events
    /// - Returns: JSONObject
    class func constructPermissionError(with errorCode: EVAWebChatContactsErrorCode.Permission) -> [String:Any]? {

        let error = EVAWebChatContactsError(permissionErrorCode: errorCode,
                                            errorMsg: nil,
                                            errorDescription:nil)
        return error.errorObj
    }
    
    //MARK: constructEventError
    /// Event Errors
    /// - Parameter errorCode: EVAWebChatContactsErrorCode.Events
    /// - Returns: JSONObject
    class func constructEventError(with errorCode: EVAWebChatContactsErrorCode.Events) -> [String:Any]? {

        let error = EVAWebChatContactsError(eventsErrorCode: errorCode,
                                            errorMsg: nil,
                                            errorDescription:nil)
        return error.errorObj
    }
}
