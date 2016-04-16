//
//  Calendar.swift
//  Apex
//
//  Created by Patrick Xu on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import Foundation
import EventKit

class Calendar {
    let eventStore: EKEventStore = EKEventStore()
    var authorized = false
    
    func getAuthorization() {
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
            insertEvent(eventStore)
        case .Denied:
            print("no access to calendar")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                (granted: Bool, error: NSError?) in
                if (granted && error == nil) {
                    self!.insertEvent(eventStore)
                } else {
                    println("Access denied")
                }
            })
        default:
            print("default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
            as! [EKCalendar]
        
        for calendar in calendars {
            if calendar.title == "ioscreator" {
                // 3
                let startDate = NSDate()
                // 2 hours
                let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
                
                // 4
                // Create Event
                var event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                
                // 5
                // Save Event in Calendar
                var error: NSError?
                let result = store.saveEvent(event, span: EKSpanThisEvent, error: &error)
                
                if result == false {
                    if let theError = error {
                        println("An error occured \(theError)")
                    }
                }
            }
        }
    }
}