//
//  EVAContactsHandler.swift
//  EVAContacts
//
//  Created by Bharathan V on 29/08/22.
//
import ContactsUI
import Contacts
import Foundation
import AVFoundation
/// ContactInfo
struct ContactInfo : Identifiable, DictionaryConvertor {
    
    var id: String              // String representing unique identifier for this contact.
    var displayName: String     // String representing display name of the contact.
    var nickName: String        // String representing nickname of the contact.
    var name: String            // String representing full name of the contact.
    var phoneNumbers: [Numbers] // Array of phone numbers associated with the contact.
    var emails: [Mail]          // Array of email addresses associated with the contact.
    var urls: [Urls]            // Array of URLs associated with the contact.
    var address: [Address]      // Array of addresses associated with the contact.
    var ims: [Ims]              // Array of instant messaging (IM) service details associated with the contact.
    var organization: String    // String representing organization or company associated with the contact.
    var birthday: Double?       // Double representing birthday of the contact as a Unix timestamp (in seconds).
    var photos: String          // Array of photos or avatars associated with the contact.

}

//Struct representing an email address associated with a contact.
struct Mail:DictionaryConvertor {
    var fields: String
    var type: String
    var primary: Bool
}
//Struct representing numbers associated with a contact.
struct Numbers:DictionaryConvertor {
    var fields: String
    var type: String
    var primary: Bool
}
//Struct representing Urls associated with a contact.
struct Urls:DictionaryConvertor {
    var fields: String
    var type: String
    var primary: Bool
}
//Struct representing address associated with a contact.
struct Address:DictionaryConvertor {
    var fields: String
    var type: String
    var primary: Bool
}
//Struct representing ims associated with a contact.
struct Ims:DictionaryConvertor {
    var fields: String
    var type: String
    var primary: Bool
}

protocol DictionaryConvertor {
    func toDictionary() -> [String : Any]
}

extension DictionaryConvertor {
    
    func toDictionary() -> [String : Any] {
        let reflect = Mirror(reflecting: self)
        let children = reflect.children
        let dictionary = toAnyHashable(elements: children)
        return dictionary
    }
    
    func toAnyHashable(elements: AnyCollection<Mirror.Child>) -> [String : Any] {
        var dictionary: [String : Any] = [:]
        for element in elements {
            if let key = element.label {
                
                if let collectionValidHashable = element.value as? [AnyHashable] {
                    dictionary[key] = collectionValidHashable
                }
                
                if let validHashable = element.value as? AnyHashable {
                    dictionary[key] = validHashable
                }
                
                if let convertor = element.value as? DictionaryConvertor {
                    dictionary[key] = convertor.toDictionary()
                }
                
                if let convertorList = element.value as? [DictionaryConvertor] {
                    dictionary[key] = convertorList.map({ e in
                        e.toDictionary()
                    })
                }
            }
        }
        return dictionary
    }
}

@objc(EVAWebChatContactsHandler)
class EVAWebChatContactsHandler: NSObject {
    
    private var mParentViewController_: UIViewController?   // Optional instance pf UIViewcontroller class.
    private var contactStore: CNContactStore    // Instance of CNContactStore class.
    private var ContactLock: NSObject?          // Synchronization lock to ensure thread safety for accessing shared resources.
    
    // MARK: Initalization
    /// Method to initialize OSEContactsHandler using top viewController
    /// @param viewController top showing viewController
    /// @param logger will use to print logs
    init?(viewController: UIViewController?) {
        
        mParentViewController_ = viewController
        //Create repository objects contacts
        contactStore = CNContactStore()
    }
    //MARK: acquireLock
    func acquireLock() -> NSObject? {
        if ContactLock == nil {
            ContactLock = NSObject()
            return ContactLock
        }
        return nil
    }
    //MARK: releaseLock
    func releaseLock(_ lock: NSObject?) {
        if lock == ContactLock {
            ContactLock = nil
        }
    }
    //MARK: checkContactsPermission
    func checkContactsPermission(_ completionHandler: @escaping (Bool) -> Void) {
        contactStore.requestAccess(for: .contacts) { granted, error in
            if granted {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }
    
    // MARK: addNewContact Event Methods
    // addNewContact: withCompletion
    /// Add New Contacts functionality
    /// - Parameters:
    ///   - addNewContactOptions: JSONObject
    ///   - completionHandler: (Bool, Error?)
    func addNewContact(_ addNewContactOptions: [String:Any], withCompletion completionHandler: @escaping (Bool, Error?) -> Void) {
        let mutableContact = CNMutableContact()
        
        let firstName = addNewContactOptions["firstName"] as? String
        let lastName = addNewContactOptions["lastName"] as? String
        let phoneNumber = addNewContactOptions["phoneNumber"] as? String
        let email = addNewContactOptions["email"] as? String
        let launchUI = addNewContactOptions["launchUI"] as? Bool
        
        if (firstName != nil) {
            mutableContact.givenName = firstName ?? ""
        }
        if (lastName != nil) {
            mutableContact.familyName = lastName ?? ""
        }
        if (email != nil) {
            mutableContact.emailAddresses = [CNLabeledValue(label: CNLabelEmailiCloud, value: email! as NSString)]
        }
        if (phoneNumber != nil) {
            mutableContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber ?? ""))] // @[[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
        }
        
//    By this we are launching default add new Contact UI
    
        if launchUI ?? false {
            let newContact = CNContactViewController(forNewContact: mutableContact)
            newContact.delegate = self
            newContact.contactStore = CNContactStore()
            let navigationController = UINavigationController(rootViewController: newContact)
            self.mParentViewController_?.navigationController?.present(navigationController, animated: false)
        } else {
            let saveRequest = CNSaveRequest()
            saveRequest.add(mutableContact, toContainerWithIdentifier: contactStore.defaultContainerIdentifier())
            do {
                try contactStore.execute(saveRequest)
                completionHandler(true, nil)
            } catch {
                completionHandler(false, nil)
            }
        }
    }
    
    // MARK: getParticularContact
    /// functionality of getting particular Contact
    /// - Parameters:
    ///   - contactOptions: JSONObject
    ///   - completionHandler: [AnyHashable : Any]
    func getParticularContact(_ contactOptions: [String:Any], withCompletion completionHandler: @escaping ([String : Any]?) -> Void) {
        let phoneNumber = contactOptions["phoneNumber"] as? String
        if phoneNumber == nil {
            print("Error: please provide valid phone number to fetch contact")
            completionHandler(nil)
        } else {
            if let contact = getParticularContact(phoneNumber) {
                
                print("phoneNumber = %@", phoneNumber ?? "")
               
                let contactDetails = getFilteredContact(contact: contact)
                
                completionHandler(contactDetails)
                
            } else {
                print("Error: fetching contact")
                completionHandler(nil)
            }
        }
    }
    
    // MARK: pickContact
    /// implementation of Picking Contatct using CNContactPickerViewController
    func pickContact(){
        let contacVC = CNContactPickerViewController()
        contacVC.delegate = self
        self.mParentViewController_?.navigationController?.present(contacVC, animated: true, completion: nil)
    }
    
    //MARK: fetchingContacts
    /// Fetching the contacts
    /// - Parameter completionHandler: [ContactInfo]
    func fetchingContacts(_ completionHandler: @escaping ([[String:Any]]?, Error?) -> Void){
        
        DispatchQueue.global(qos: .default).async {
            var contacts = [[String:Any]]()
            let keys = [CNContactIdentifierKey,
                        CNContactEmailAddressesKey,
                        CNContactBirthdayKey,
                        CNContactImageDataKey,
                        CNContactPhoneNumbersKey,
                        CNContactGivenNameKey,
                        CNContactFamilyNameKey,
                        CNContactNamePrefixKey,
                        CNContactNicknameKey,
                        CNContactUrlAddressesKey,
                        CNContactOrganizationNameKey,
                        CNContactInstantMessageAddressesKey,
                        CNContactPostalAddressesKey,
                        //CNContactNoteKey,
                        CNContactImageDataKey,]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
            do {
                try CNContactStore().enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                    
                    let filteredContact = self.getFilteredContact(contact: contact)
                    contacts.append(filteredContact)
                    
                })
            } catch let error {
                print("Failed", error)
            }
            contacts = contacts.sorted {
                (($0["name"] as? String) ?? "") < (($1["name"] as? String) ?? "")
            }
            completionHandler(contacts, nil)
        }
        // return contacts
    }
    
    // MARK: updateContact
    /// Updating Functionality of Contact
    /// - Parameters:
    ///   - updateContactOptions: JSONObject
    ///   - completionHandler: @escaping (Bool, Error)
    
    func updateContact(_ updateContactOptions: [String:Any], withCompletion completionHandler: @escaping (Bool, Error?) -> Void) {
        let updateUI = updateContactOptions["updateUI"] as? Bool
        let phoneNumber = updateContactOptions["phoneNumber"] as? String
            if phoneNumber == nil {
                completionHandler(false, nil)
            } else {
                if let contact = getParticularContact(phoneNumber) {
                    if updateUI ?? false {
                        let updateContact = CNContactViewController(for: contact)
                        updateContact.delegate = self
                        updateContact.allowsEditing = true
                        let navigationController = UINavigationController(rootViewController: updateContact)
                        self.mParentViewController_?.navigationController?.present(navigationController, animated: false)
                    } else {
                        let mutableContact = contact.mutableCopy() as? CNMutableContact
                    
                        let firstName = updateContactOptions["firstName"] as? String
                        let lastName = updateContactOptions["lastName"] as? String
                        let phoneNumber = updateContactOptions["phoneNumber"] as? String
                        let email = updateContactOptions["email"] as? String
                        
                    
                        if let firstName = firstName {
                            mutableContact?.givenName = firstName
                        }
                        if let lastName = lastName {
                            mutableContact?.familyName = lastName
                        }
                        if let emails = email {
                            mutableContact?.emailAddresses = [CNLabeledValue(label: CNLabelEmailiCloud, value: emails as NSString)]
                        }
                        if let phoneNumber = phoneNumber {
                            mutableContact?.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))] // @[[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
                        }
                   
                        let saveRequest = CNSaveRequest()
                        if let mutableContact = mutableContact {
                            saveRequest.update(mutableContact)
                        }
                        do {
                            try contactStore.execute(saveRequest)
                            if true {
                                completionHandler(true, nil)
                            }
                        } catch {
                            completionHandler(false, nil)
                        }
                    }
                } else {
                    print("Error: fetching contact")
                    completionHandler(false, nil)
                }
            }
    }
    
    // MARK: deleteContact Event Methods
    /// Delete Conatct
    /// - Parameters:
    ///   - deleteContactOptions: JSONObject
    ///   - completionHandler: (Bool, Error?)
    func deleteContact(_ deleteContactOptions: [String:Any], withCompletion completionHandler: @escaping (Bool, Error?) -> Void) {
        let phoneNumber = deleteContactOptions["phoneNumber"] as? String
        if phoneNumber == nil {
            print("Error: please provide valid phone number to delete contact")
            completionHandler(false, nil)
        } else {
            if let contact = getParticularContact(phoneNumber) {
            
                let mutableContact = contact.mutableCopy() as? CNMutableContact
                if let phoneNumber = phoneNumber {
                    mutableContact?.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber(stringValue: phoneNumber))] // @[[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
                }
                let deleteRequest = CNSaveRequest()
                if let mutableContact = mutableContact {
                    deleteRequest.delete(mutableContact)
                }
                do {
                    try contactStore.execute(deleteRequest)
                    if true {
                        completionHandler(true, nil)
                    }
                } catch {
                    completionHandler(false, nil)
                }
            } else {
                print("Error: fetching contact")
                completionHandler(false, nil)
            }
        }
    }
    
    //MARK: getParticularContact
    /// get a Particular Contact by fetching Keys
    /// - Parameter phoneNumber: String
    func getParticularContact(_ phoneNumber: String?) -> CNContact? {
        let predicate = CNContact.predicateForContacts(matching: CNPhoneNumber(stringValue: phoneNumber ?? ""))
        
        let keysToFetch = [CNContactIdentifierKey,
                           CNContactEmailAddressesKey,
                           CNContactBirthdayKey,
                           CNContactImageDataKey,
                           CNContactPhoneNumbersKey,
                           CNContactGivenNameKey,
                           CNContactFamilyNameKey,
                           CNContactNamePrefixKey,
                           CNContactNicknameKey,
                           CNContactUrlAddressesKey,
                           CNContactOrganizationNameKey,
                           CNContactInstantMessageAddressesKey,
                           CNContactPostalAddressesKey,
                           //CNContactNoteKey,
//                           CNContactFormatter.descriptorForRequiredKeys(for: .fullName).description,
                           CNContactViewController.descriptorForRequiredKeys()
        ] as [Any]
        let keyDescriptor = keysToFetch.compactMap{$0 as? CNKeyDescriptor}
        var contacts: [CNContact]? = nil
        do {
             contacts = try contactStore.unifiedContacts(
                matching: predicate,
                keysToFetch: keyDescriptor)
            
            var contactList: [CNContact] = []
            for contact in contacts ?? [] {
                contactList.append(contact)
            }
            if contactList.count > 0 {
                return contacts?.first
            } else {
                return nil
            }
        } catch {
            print("error fetching contacts %@", error as CVarArg)
            return nil
        }
    }
    
    //MARK: getFilteredContacts
    /// Get contacts details as per input data
    /// - Parameter contact: CNContact
    func getFilteredContact(contact : CNContact) -> [String:Any] {
        
        var labelType = [String]()
        var number = [Numbers]()
        var mail = [Mail]()
        var url = [Urls]()
        var address = [Address]()
        var instantMessenger = [Ims]()
        
        for phoneNumber:CNLabeledValue in contact.phoneNumbers {
            let type :String  =  CNLabeledValue<NSString>.localizedString(forLabel: phoneNumber.label ?? "")
            labelType.append(type)
            number.append(Numbers.init(fields: contact.phoneNumbers.first?.value.stringValue ?? "", type: type, primary: false))
        }
        
        for email:CNLabeledValue in contact.emailAddresses {
            let type :String  =  CNLabeledValue<NSString>.localizedString(forLabel: email.label ?? "")
            labelType.append(type)
            mail.append(Mail.init(fields: (contact.emailAddresses.first?.value ?? "") as String, type: type, primary: false))
        }
        
        for urlAddress:CNLabeledValue in contact.urlAddresses {
            let type :String  =  CNLabeledValue<NSString>.localizedString(forLabel: urlAddress.label ?? "")
            labelType.append(type)
            url.append(Urls.init(fields: (contact.urlAddresses.first?.value ?? "") as String, type: type, primary: false))
        }
        
        for postal:CNLabeledValue in contact.postalAddresses {
            let type :String = CNLabeledValue<NSString>.localizedString(forLabel: postal.label ?? "")
            labelType.append(type)
            let postalAddress = postal.value
            let formatter = CNPostalAddressFormatter()
            let formatterAddress = formatter.string(from: postalAddress)
            address.append(Address.init(fields: formatterAddress, type: type, primary: false))
        }
        
        for ims:CNLabeledValue in contact.instantMessageAddresses {
            let type :String = CNLabeledValue<NSString>.localizedString(forLabel: ims.label ?? "")
            labelType.append(type)
            instantMessenger.append(Ims.init(fields: ((contact.postalAddresses.first?.value ?? "" as NSObject) as! String), type: type, primary: false))
        }
        
        let base64String = convertImageToBase64String(contact: contact)
        
        return ContactInfo(id: contact.identifier,displayName: contact.namePrefix,nickName: contact.nickname,name: contact.givenName, phoneNumbers: number, emails: mail, urls: url, address: address, ims: instantMessenger, organization: contact.organizationName, birthday: contact.birthday?.date?.timeIntervalSince1970, photos: base64String).toDictionary()
    }
    
    //MARK: convertImageToBase64String
    /// Converts Image to Base64 String
    /// - Parameter contact: CNContact
    func convertImageToBase64String(contact : CNContact) -> String {
        if let imageData = contact.imageData, let image = UIImage(data: imageData){
            let imageData = image.jpegData(compressionQuality: 1)
            let base64String = imageData!.base64EncodedString()
            return base64String
        }
        return ""
    }
}

    //MARK:CNContactViewControllerDelegate,CNContactPickerDelegate
    ///Implementation of Contact delegate Methods
extension EVAWebChatContactsHandler:CNContactViewControllerDelegate,CNContactPickerDelegate {
    
    // MARK: contactViewController
    /// Contact Viewer
    /// - Parameters:
    ///   - picker: CNContactPickerViewController
    ///   - contact: CNContact
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        self.mParentViewController_?.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: contactPicker
    /// Contact Picker Delegate
    /// - Parameters:
    ///   - picker: CNContactPickerViewController
    ///   - contact: CNContact
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        let filteredContacts = getFilteredContact(contact: contact)
        
        NotificationCenter.default.post(name: Notification.Name("ContactPickerSucess"), object: filteredContacts, userInfo: nil)
    }
    // MARK: contactPickerDidCancel
    /// Cancels Contact Picker
    /// - Parameter picker: CNContactPickerViewController
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        NotificationCenter.default.post(name: Notification.Name("ContactPickerDidCancel"), object: "cancel", userInfo: nil)
        self.mParentViewController_?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
