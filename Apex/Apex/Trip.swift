//
//  Trip.swift
//  Apex
//
//  Created by Patrick Xu on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import Foundation
import Firebase

class Trip {
    
    static let ref = Firebase(url: "https://apexdatabase.firebaseio.com/trips")
    
    // a Trip in the database MUST have these fields
    var name: String = ""
    var leaders: [String] = []
    var maxMembers: Int = 0
    var cost: Int = 0
    var tags: [String] = []
    var lat: Int = 0
    var long: Int = 0
    
    // these fields are optional
    var members: [String] = []

    
    init(name: String, leaders: [String], maxMembers: Int, cost: Int, tags: [String], lat: Int, long: Int, members: [String]) {
        self.name = name
        self.leaders = leaders
        self.maxMembers = maxMembers
        self.cost = cost
        self.tags = tags
        self.lat = lat
        self.long = long
        self.members = members
    }
    
    // returns true if user was able to join trip
    func joinTrip(userID: String) -> Bool {
        if getRemainingSpots() < maxMembers {
            members.append(userID)
            return true
        } else {
            return false
        }
    }
    
    func getRemainingSpots() -> Int {
        return maxMembers - leaders.count - members.count
    }
    
    /** get all current trips as an array
     example:
     
     @IBAction func tripTest(sender: AnyObject) {
        Trip.getTrips(myfunc)
     }
     
     func myfunc(trips: [Trip]) {
        print(trips)
     }
 
     **/
    static func getTrips(callback:(trips: [Trip]) -> Void) {
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var trips = [Trip]()
            print("getting trips: ")
            for trip in snapshot.children {
                print(trip.value.objectForKey("name") as! String)
                
                let name = trip.value.objectForKey("name") as! String
                let leaders = trip.value.objectForKey("leaders") as! [String]
                let maxMembers = trip.value.objectForKey("maxMembers") as! Int
                let cost = trip.value.objectForKey("cost") as! Int
                let tags = trip.value.objectForKey("tags") as! [String]
                let lat = trip.value.objectForKey("lat") as! Int
                let long = trip.value.objectForKey("long") as! Int
                var members = trip.value.objectForKey("members") as? [String]
                if members == nil {
                    members = []
                }
                
                trips.append(Trip(name: name, leaders: leaders, maxMembers: maxMembers, cost: cost, tags: tags, lat: lat, long: long, members: members!))
            }
            callback(trips: trips)
        }, withCancelBlock: { error in
            print(error.description)
        })
    }
    
    
}