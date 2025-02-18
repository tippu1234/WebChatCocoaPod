//
//  EVAWebChatCalendarHandler.swift
//  EVAWebChatCalendarHandler
//
//  Created by Raghavendra V on 08/05/24.


import Foundation
import EventKit
import EventKitUI


@objc(EVAWebChatCalendarHandler)
class EVAWebChatCalendarHandler: NSObject, UINavigationControllerDelegate {
  
    var calendar_: EKCalendar? = nil            // Optional instance of EKCalendar class for managing calendar.
    var store: EKEventStore? = nil              // Optional instance of EKEventStore class for managing events.
    var dateFormatter: DateFormatter? = nil     // Date formatter for date-related operations.
    private var mParentViewController_: UIViewController?   // Optional instance of UIViewController for managing view controllers.
    private var createEventLaunchUICompletionHandler: ((Bool, String) -> Void)! = nil
        // A completion handler for creating an event in the UI.
        // The closure takes a boolean indicating success and a string for additional information.

    private var modifyEventLaunchUICompletionHandler: ((Bool, String) -> Void)! = nil
        // A completion handler for modifying an event in the UI.
        // The closure takes a boolean indicating success and a string for additional information.


    // MARK: appContent
    /// Init IApplicationContext with Logger
    /// - Parameters:
    ///   - appContent: IApplicationContext
    ///   - logger: Logger
    init(viewController: UIViewController?) {
        super.init()
        mParentViewController_ = viewController
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        initializeCalendar()
    }
    func initializeCalendar() {
        if (calendar_ == nil) {
            store = EKEventStore()
            calendar_ = store?.defaultCalendarForNewEvents
        }
    }
    // MARK: requestAuthorization
    /// requestAuthorization
    /// - Parameters:
    ///   - completion: (Bool, String)
    func requestAuthorization(
        withCompletion completion: @escaping (_ result: Bool, _ message: String?) -> Void) {
            var errorStr: String? = nil
            var doPrompt = false
            let permissions = EKEventStore.authorizationStatus(for: EKEntityType.event)
            if permissions != .authorized {
                switch permissions {
                    case EKAuthorizationStatus.notDetermined:
                        doPrompt = true
                    case EKAuthorizationStatus.denied:
                        errorStr = "The user has denied access to events in Calendar."
                    case EKAuthorizationStatus.restricted:
                        errorStr = "The user is unable to allow access to events in Calendar."
                    default:
                        break
                }
                if doPrompt {
                    
                    if #available(iOS 17.0, *) {
                        store?.requestFullAccessToEvents(completion: { granted, error in
                            
                            let message = granted ? "Permission granted to access events in Calendar." : "The user has denied access to events in Calendar."
                            completion(granted, message)
                        })
                    } else {
                        // Fallback on earlier versions
                        store?.requestAccess(
                            to: .event) { granted, error in
                                
                                let message = granted ? "Permission granted to access events in Calendar." : "The user has denied access to events in Calendar."
                                completion(granted, message)
                            }
                    }
                } else {
                    if #available(iOS 17.0, *) {
                        if permissions == .writeOnly || permissions == .fullAccess {
                            completion(true, "Permission already granted to access events in calendar.")
                        } else {
                            completion(false, "The user is unable to allow access to events in Calendar.")
                        }
                    } else {
                        completion(false, errorStr)
                    }
                }
            } else {
                completion(true, "Permission already granted to access events in Calendar.")
            }
        }
    
    // MARK: hasCalendarPermissions
    /// Handles the required permissions for the usage of Calendars
    /// - Returns: Bool
    func hasCalendarPermissions() -> Bool {
        let calendarPermission = Bundle.main.object(forInfoDictionaryKey: "NSCalendarsUsageDescription") as? String
        if calendarPermission == nil {
            print("[ERROR] iOS 10 and later requires the key \"NSCalendarsUsageDescription\" inside the plist in your tiapp.xml when accessing the native calendar. Please add the key and re-run the application.")
        }
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
            
    // MARK: createEvent
    /// Functionality of creating new event in calendar.
    /// - Parameters:
    ///    - eventData: JSONObject
    func createEvent(_ eventData: [String:Any]) -> String? {
        
        if let store = self.store {
            
            let event = EKEvent(eventStore: store)
            if let newEvent = getEKEventUsingInputJSON(eventData, event) {
                do {
                    try store.save(newEvent, span: .thisEvent, commit: true)
                    let eventId = newEvent.eventIdentifier
                    return eventId
                } catch let error as NSError {
                    print("Error: %@", error.localizedDescription)
                    return nil
                }
            }
        }
        return nil
    }
    
    // MARK: createEventUsingLaunchUI
    /// createEventUsingLaunchUI
    /// - Parameters:
    ///    - eventData: JSONObject
    ///    - completion: @escaping (Bool,String)
    func createEventUsingLaunchUI(_ eventData: [String:Any], _ completion: @escaping (Bool,String) -> Void){
        
        DispatchQueue.main.async(execute: { [weak self] in
            if let store = self?.store {
                let event = EKEvent(eventStore: store)
                if let newEvent = self?.getEKEventUsingInputJSON(eventData,event) {
                    self?.createEventLaunchUICompletionHandler = completion
                    let newEventvc = EKEventEditViewController()
                    newEventvc.event = newEvent
                    newEventvc.editViewDelegate = self
                    newEventvc.eventStore = store
                    self?.mParentViewController_?.navigationController?.present(newEventvc, animated: true)
                } else {
                    self?.createEventLaunchUICompletionHandler(false, "Unable to create event")
                }
            }
        })
    }
        
    // MARK: modifyEvent
    ///createEvent
    /// - Parameters:
    ///    - eventData: JSONObject
    func modifyEvent(_ eventData: [String:Any]) -> String? {
        
        if let eventId = eventData["eventId"] as? String, let eventDetails = store?.event(withIdentifier: eventId), let event = self.getEKEventUsingInputJSON(eventData, eventDetails) {
            do {
                try store?.save(event, span: .thisEvent, commit: true)
                return event.eventIdentifier
            } catch {
                
            }
        }
        return nil
    }
     
    // MARK: modifyEventUsingLaunchUI
    /// modifyEventUsingLaunchUI
    /// - Parameters:
    ///    - eventData: JSONObject
    ///    - completion: @escaping (Bool,String)
    func modifyEventUsingLaunchUI(_ eventData: [String:Any], _ completion: @escaping (Bool,String) -> Void){
        
        if let eventId = eventData["eventId"] as? String, let eventDetails = store?.event(withIdentifier: eventId) {
            
            DispatchQueue.main.async(execute: {

                self.modifyEventLaunchUICompletionHandler = completion
                
                let newEventvc = EKEventEditViewController()
                newEventvc.event = eventDetails
                newEventvc.editViewDelegate = self
                newEventvc.eventStore = self.store
                self.mParentViewController_?.navigationController?.present(newEventvc, animated: true)
            })
        } else {
            completion(false, "Please provide valid eventId")
        }
    }
    
    // MARK: searchEvent
    /// searchEvent
    /// - Parameters:
    ///    - eventData: JSONObject
    ///    - completion: @escaping (Bool,JSOnArray,String)
    func searchEvent(_ eventData: [String:Any], withcompletion completionHandler: @escaping (Bool, [[String:Any]], String) -> Void) {
       
        var results = [EKEvent]()
        let eventStartDateString: String? = eventData["eventStartDate"] as? String
        let eventEndDateString: String? = eventData["eventEndDate"] as? String
        
        if eventStartDateString != nil || eventEndDateString != nil {
            
            let eventStartDate = getDateFromJsonInput(eventStartDateString)
            let eventEndDate = getDateFromJsonInput(eventEndDateString)
            
            let datePredicates = store?.predicateForEvents(withStart: eventStartDate!, end: eventEndDate!, calendars: store?.calendars(for: .event))
            let datedEvents = NSArray(array:store?.events(matching: datePredicates!) ?? [])
            var predicateStringArray:[String] = []
            if let title = eventData["title"] as? String {
                let titlePredicate = String(format: "title contains[c] '%@'",title)
                predicateStringArray.append(titlePredicate)
            }
            
            if let notes = eventData["notes"] as? String {
                let notePredicate = String(format: "notes like '%@'", notes)
                predicateStringArray.append(notePredicate)
            }
            
            if let location = eventData["location"] as? String {
                let locationPredicate = String(format: "location like '%@'", location)
                predicateStringArray.append(locationPredicate)
            }
            
            let predicateString = predicateStringArray.joined(separator: " AND ")
            var filteredEvents:[[String:Any]] = []
            if predicateStringArray.count > 0 {
                let matches = NSPredicate(format: predicateString)
                results = datedEvents.filtered(using: matches) as? [EKEvent] ?? []
                for eachEvent in results {
                    filteredEvents.append(self.getEventDetails(byId: eachEvent.eventIdentifier))
                }
                completionHandler(true, filteredEvents, "Success")
            } else {
                completionHandler(false, filteredEvents, "Please provide valid search input ")
            }
        } else {
            completionHandler(false, [], "Please provide valid input dates")
        }
    }
    
    // MARK: getEKEventUsingInputJSON
    /// Gets the event Details by the input of Input JSON
    /// - Parameters:
    ///    - eventData: JSONObject
    ///    - event: EKEvent
    func getEKEventUsingInputJSON(_ eventData: [String:Any],_ event: EKEvent?) -> EKEvent? {
        
        if let event = event {
               
            let eventTitle:String = (eventData["title"] as? String) ?? ""
            let eventNotes:String = (eventData["notes"] as? String) ?? ""
            let eventLocation:String = (eventData["location"] as? String) ?? ""
            let isForAllDays:Bool = (eventData["isForAllDays"] as? Bool) ?? false
            
            
            let eventStartDateValue = eventData["eventStartDate"]
            let eventEndDateValue = eventData["eventEndDate"]
            let eventStartDate = getDateFromJsonInput(eventStartDateValue)
            let eventEndDate = getDateFromJsonInput(eventEndDateValue)
            
            let alarms:[Any] = (eventData["alarms"] as? [Any]) ?? []
            var allAlarms:[EKAlarm] = []
            
            for i in 0..<alarms.count{
                let eachAlarmOffset = alarms[i]
                var alarmOffset = 0.0
                if eachAlarmOffset is String {
                    let eachAlarmOffsetString = eachAlarmOffset as? String
                    if eachAlarmOffsetString != nil && (eachAlarmOffsetString?.count ?? 0) > 0 {
                        alarmOffset = (Double(eachAlarmOffsetString ?? "") ?? 0.0) * 60
                    }
                } else {
                    let eachAlarmOffsetDouble = eachAlarmOffset as? NSNumber
                    alarmOffset = (eachAlarmOffsetDouble?.doubleValue ?? 0.0) * 60
                }
                
                if alarmOffset > 0 {
                    alarmOffset = alarmOffset * -1
                }
                let alarm = EKAlarm(relativeOffset: TimeInterval(alarmOffset))
                allAlarms.append(alarm)
            }
            
            if (eventStartDate != nil) && (eventEndDate != nil) {
                event.title = eventTitle
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                event.calendar = calendar_
                event.notes = eventNotes
                event.isAllDay = isForAllDays
                event.alarms = allAlarms
                event.location = eventLocation
            }
            return event
        }
        return nil
    }
    
    // MARK: getFilteredDate
    /// Gets Filtered date by using Ranges
    /// - Parameters:
    ///    - dateString: String
    func getFilteredDate(fromDateString dateString: String?) -> Date? {
        var dateString: NSString = dateString as NSString? ?? ""
        var timezone: NSTimeZone? = NSTimeZone.default as NSTimeZone
        if dateString.contains("[") && dateString.contains("]") {
            let searchFromRange: NSRange = dateString.range(of: "[")
            let searchToRange: NSRange = dateString.range(of: "]")
            let substring: NSString = dateString.substring(with: NSRange(location: searchFromRange.location + searchFromRange.length, length: searchToRange.location - searchFromRange.location - searchFromRange.length)) as NSString
            if substring.contains("/") {
                timezone = NSTimeZone(name: substring as String) ?? NSTimeZone.default as NSTimeZone
                if timezone != nil{
                    timezone = NSTimeZone.default as NSTimeZone
                }
            } else if substring.length > 0 {
                timezone = NSTimeZone(abbreviation: substring.uppercased)
                if (timezone == nil) {
                    timezone = NSTimeZone.default as NSTimeZone
                }
            }
            dateString = dateString.substring(with: NSRange(location: 0, length: searchFromRange.location)) as NSString
        }
        dateFormatter?.timeZone = timezone as TimeZone?
        return dateFormatter?.date(from: dateString as String)
    }
    
    // MARK: getDateFromJsonInput
    /// Get Date details by JSON Input
    /// - Parameters:
    ///    - eventDateString: String
    func getDateFromJsonInput(_ eventDateInput: Any?) -> Date? {
//        let nf = NumberFormatter()
        
        /*let isNumber = nf.number(from: eventDateString ?? "") != nil
        var eventDate : Date?
        if isNumber {
            //Number date flow
            var eventDateValue = 0.0
            if eventDateString != nil && (eventDateString?.count ?? 0) > 0 {
                eventDateValue = Double(eventDateString ?? "") ?? 0.0
            } else {
                eventDateValue = Date().timeIntervalSince1970
            }
            eventDate = Date(timeIntervalSince1970: TimeInterval(eventDateValue))
        } else {
            eventDate = getFilteredDate(fromDateString: eventDateString)
        }*/
        var eventDate : Date?
        if eventDateInput is NSNumber {
            var eventDateValue:Double = (eventDateInput as? NSNumber ?? 0.0).doubleValue
            if eventDateValue <= 0 {
                eventDateValue = Date().timeIntervalSince1970
            }
            eventDate = Date.init(timeIntervalSince1970: eventDateValue)
        } else {
            eventDate = getDateFromJsonInput(eventDateInput as? String)
        }
        return eventDate
    }
    // MARK: - getEventDetail
    ///Get Event Details by Event ID
    ///    - Parameters:
    ///    - eventId: String
    func getEventDetails(byId eventId: String?) -> [String:Any] {
        var eventDetails:[String:Any] = [:]
        let event_ = store?.event(withIdentifier: eventId ?? "")
        if let event_ = event_ {
            eventDetails["id"] = event_.eventIdentifier
            eventDetails["title"] = event_.title
            eventDetails["startDate"] = NSNumber(value: event_.startDate.timeIntervalSince1970)
            eventDetails["endDate"] = NSNumber(value: event_.endDate.timeIntervalSince1970)
            dateFormatter?.dateFormat = "yyyy-mm-dd'T'HH:mm:ss.SSS'Z'"
            let dateString = dateFormatter?.string(from: event_.lastModifiedDate!)
            eventDetails["lastModified"] = dateString
            eventDetails["loctaion"] = event_.location
            eventDetails["note"] = event_.notes
            
            var attendeesArray:[[String:Any]] = []
            for attende in event_.attendees ?? [] {
                var attendeDetails:[String:Any] = [:]
                attendeDetails["name"] = attende.name
                attendeDetails["url"] = attende.url.absoluteString
                attendeDetails["status"] = attende.participantStatus.rawValue
                attendeDetails["type"] = attende.participantType.rawValue
                attendeDetails["role"] = attende.participantRole.rawValue
                attendeesArray.append(attendeDetails)
            }
            eventDetails["attendess"] = attendeesArray
            
            var recurrenceArray:[[String:Any]] = []
            for rule in event_.recurrenceRules ?? [] {
                var recurrenceDetails:[String:Any] = [:]
                recurrenceDetails["Calendar"] = rule.calendarIdentifier
                recurrenceDetails["frequency"] = rule.frequency.rawValue
                recurrenceDetails["interval"] = rule.interval
                recurrenceDetails["endDate"] = NSNumber(value: rule.recurrenceEnd?.endDate?.timeIntervalSince1970 ?? 0)
                recurrenceDetails["count"] = rule.recurrenceEnd?.occurrenceCount
                recurrenceArray.append(recurrenceDetails)
            }
            eventDetails["reccurrance"] = recurrenceArray
        }
        return eventDetails
    }
    // MARK: - listEvents
    /// To get list of Events from Calendar Functionality
    ///    - Parameters:inputData: JSONObject
    ///    - inputData: JSONObject
    
    func listEvents(_ inputData: [String:Any]) -> [[String:Any]] {
        let eventIds: [Any] = (inputData["eventIds"] as? [Any]) ?? []
        var allEvents:[[String:Any]] = []
        if eventIds.count != 0 && ((eventIds as AnyObject).count ?? 0) > 0 {
            for eachEventId in eventIds {
                guard let eachEventId = eachEventId as? String else {
                    continue
                }
                let eachEventDetails = getEventDetails(byId: eachEventId)
                allEvents.append(eachEventDetails)
            }
        } else {
            //List all events
            let numberOfDays: Int? = inputData["numberOfDays"] as? Int ?? 0
            var numberOfDaysValue = 7.0
            if let numberOfDays = numberOfDays {
                if Double(numberOfDays) > 0 {
                    numberOfDaysValue = Double(numberOfDays)
                }
            }
            allEvents = fetchAllEventsbetweenDate(
                    Date(),
                    andDate: Date().addingTimeInterval(TimeInterval((60 * 60 * 24) * numberOfDaysValue)))
        }
        return allEvents
    }
    
    // MARK: - _fetchAllEventsbetweenDate
    /// Fetching of events between the dates
    ///    - Parameters:
    ///    - startDate:Date
    ///    - endDate: Date
    func fetchAllEventsbetweenDate(_ startDate:Date?,andDate endDate:Date?) -> [[String:Any]] {
        var allEvents:[[String:Any]] = []
        if let store = store, let calendar = calendar_ {
            var predicate: NSPredicate? = nil
            if let startDate = startDate, let endDate = endDate {
                predicate = store.predicateForEvents(
                    withStart: startDate,
                    end: endDate,
                    calendars: [calendar])
            }
            var arrayOfEvents: [EKEvent]? = nil
            if let predicate = predicate {
                arrayOfEvents = store.events(matching: predicate)
            }
            for eachEvent in arrayOfEvents ?? [] {
                let eachEventDetails = getEventDetails(byId: eachEvent.eventIdentifier)
                allEvents.append(eachEventDetails)
            }
            
        }
        return allEvents
    }
    
    // MARK: deleteEvent byID
    /// Deleting Event by ID
    ///    - Parameters:
    ///    - eventId: String
    func deleteEvent(byId eventId: String?) -> Bool {
        let eventToRemove = store?.event(withIdentifier: eventId ?? "")
        if let eventToRemove = eventToRemove {
            return ((try? store?.remove(eventToRemove, span: .thisEvent, commit: true)) != nil)
        }
        return false
    }
    
    // MARK: deleteEvent
    /// Deleting of Events from the Calendat
    /// - Parameter inputData: inputData: JSONObject
    /// - Returns: Bool
    func deleteEvent(_ inputData: [String:Any]) -> Bool {
        let eventIds: [Any] = (inputData["eventIds"] as? [Any]) ?? []
        var overallResult = true
        if eventIds.count != 0 && ((eventIds as AnyObject).count ?? 0) > 0 {
            //Delete list of input events
            //if let eventIds = eventIds {
            for eachEventId in eventIds {
                guard let eachEventId = eachEventId as? String else {
                    continue
                }
                let result = deleteEvent(byId: eachEventId)
                if !result {
                    overallResult = false
                }
            }
        } else {
            //Delete all events
            let numberOfDays: Int? = inputData["numberOfDays"] as? Int ?? 0
            var numberOfDaysValue = 7.0
            if let numberOfDays = numberOfDays {
                if Double(numberOfDays) > 0 {
                    numberOfDaysValue = Double(numberOfDays)
                }
            }
            if let store = store {
                let predicate = store.predicateForEvents(
                    withStart: Date(),
                    end: Date().addingTimeInterval(TimeInterval((60 * 60 * 24) * numberOfDaysValue)),
                    calendars: [calendar_] as? [EKCalendar])
                
                let arrayOfEvents = store.events(matching: predicate)
                for eachEvent in arrayOfEvents {
                    let result = deleteEvent(byId: eachEvent.eventIdentifier)
                    if !result {
                        overallResult = false
                    }
                }
            } else {
                overallResult = false
            }
        }
        return overallResult
    }
    
}

extension EVAWebChatCalendarHandler: EKEventEditViewDelegate {
  
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        var message = "Unable to create event"
        var messageStatus = false

        switch action {
            case .canceled, .cancelled:
                message = "User is cancelled create/modify event UI"
                break
            case .saved:
                messageStatus = true
                if let eventIdentifier = controller.event?.eventIdentifier {
                    message = eventIdentifier
                }
                break
            case .deleted:
                message = "Event is deleted"
                break
            @unknown default:
                break
        }
        
        print("EVAWebChatCalendarHandler : eventEditViewController : didCompleteWith : message : \(message)")

        if createEventLaunchUICompletionHandler != nil {
            createEventLaunchUICompletionHandler(messageStatus, message)
            createEventLaunchUICompletionHandler = nil
        }
        if modifyEventLaunchUICompletionHandler != nil {
            modifyEventLaunchUICompletionHandler(messageStatus, message)
            modifyEventLaunchUICompletionHandler = nil
        }
        self.mParentViewController_?.navigationController?.dismiss(animated: true, completion: nil)
    }
}

