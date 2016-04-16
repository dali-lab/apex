//
//  Calendar.swift
//  Apex
//
//  Created by Patrick Xu on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import Foundation
import EventKit
import SCLAlertView

class Calendar {
    
    // get user authorization for adding to the calendar
    static func getAuthorization() -> Bool {
        var authorized = false
        let eventStore: EKEventStore = EKEventStore()
        switch EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) {
        case .Authorized:
             authorized = true
        case .Denied:
            print("no access to calendar")
        case .NotDetermined:
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
                (granted: Bool, error: NSError?) in
                if (granted && error == nil) {
                    authorized = true
                } else {
                    print("Access denied")
                }
            })
        default:
            print("default")
        }
        
        return authorized
    }
    
    /**
     Add an event to the calendar
     
     example code:
     
     @IBAction func calendarAction(sender: AnyObject) {
        let start = NSDate()
        let end = start.dateByAddingTimeInterval(2*60*60)  // 2 hours
        Calendar.insertEvent("Easy hike", startDate: start, endDate: end)
     }
     
     **/
    static func insertEvent(title: String, startDate: NSDate, endDate: NSDate) {
        let eventStore: EKEventStore = EKEventStore()
        if getAuthorization() {
            // create event
            let event = EKEvent(eventStore: eventStore)
            event.calendar = eventStore.defaultCalendarForNewEvents
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            
            // save event (immediately)
            do {
                try eventStore.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                notificationForEvent(title)
            } catch {
                print("Calendar event save failed")
            }
            
        } else {
            print("unable to add event due to lack of permission")
        }
    }
    
    // pop up calendar notification
    static func notificationForEvent(title: String) {
        let alert = SCLAlertView()
        alert.showInfo("Added " + title, subTitle:"Apex added " + title + " to your calendar")
    }
}