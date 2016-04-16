//
//  HomeFeedViewController.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit
import Firebase



// TRIP
class TripClass {
    
    static let ref = Firebase(url: "https://apexdatabase.firebaseio.com.firebaseio.com")
    static let tripRef = Firebase(url: "https://apexdatabase.firebaseio.com/trips")
    
    // a Trip in the database MUST have these fields
    var name: String = ""
    var leaders: [String] = []
    var maxMembers: Int = 0
    var cost: Int = 0
    var tags: [String] = []
    var lat: CGFloat = 0.0
    var long: CGFloat = 0.0
    var description: String = ""
    var startTime: Double = 0
    var endTime: Double = 0
    
    // these fields are optional
    var members: [String] = []

    
    
    init(name: String, leaders: [String], maxMembers: Int, cost: Int, tags: [String], lat: CGFloat, long: CGFloat, members: [String], description: String, startTime: Double, endTime: Double) {
        self.name = name
        self.leaders = leaders
        self.maxMembers = maxMembers
        self.cost = cost
        self.tags = tags
        self.lat = lat
        self.long = long
        self.members = members
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
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
    
    // returns true if the user was able to leave the trip
    func leaveTrip(userID: String) -> Bool {
        var leftTrip = false
        for index in 1...members.count {
            if members[index-1] == userID {
                members.removeAtIndex(index)
                leftTrip = true
            }
        }
        if leftTrip == false {
            print("unable to leave the trip even though i'm supposed to be in there")
        }
        
        return leftTrip
    }
    
    func getRemainingSpots() -> Int {
        return maxMembers - leaders.count - members.count
    }
    
    func getRegistrationText() -> String {
        var string = ""
        if self.getRemainingSpots() == 0 { // remaining
            string = "Trip is full"
        } else {
            string = String(self.getRemainingSpots()) + " " + (self.getRemainingSpots() == 0 ? "spot": "spots") + " remaining"
        }
        
        if self.cost == 0 { //cost
            string = string + ", Free"
        } else {
            string = string + ", $" + String(self.cost)
        }
        
        return string
    }
    
    class func getTrips(callback:(trips: [TripClass]) -> Void) {
        tripRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var trips = [TripClass]()
            print("getting trips: ")
            for trip in snapshot.children {
                print(trip.value.objectForKey("name") as! String)
                
                let name = trip.value.objectForKey("name") as! String
                let leaders = trip.value.objectForKey("leaders") as! [String]
                let maxMembers = trip.value.objectForKey("maxMembers") as! Int
                let cost = trip.value.objectForKey("cost") as! Int
                let tags = trip.value.objectForKey("tags") as! [String]
                let lat = trip.value.objectForKey("lat") as! CGFloat
                let long = trip.value.objectForKey("long") as! CGFloat
                var members = trip.value.objectForKey("members") as? [String]
                if members == nil {
                    members = []
                }
                let description = trip.value.objectForKey("description") as! String
                let startTime = trip.value.objectForKey("startTime") as! Double
                let endTime = trip.value.objectForKey("endTime") as! Double
                
                trips.append(TripClass(name: name, leaders: leaders, maxMembers: maxMembers, cost: cost, tags: tags, lat: lat, long: long, members: members!, description: description, startTime: startTime, endTime: endTime))
            }
            callback(trips: trips)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    class func getMyTrips(callback:(trips: [TripClass]) -> Void) {
        tripRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            var trips = [TripClass]()
            let uid = UserManager.uid
            print("getting trips: ")
            for trip in snapshot.children {
                print(uid)
                let members = trip.value.objectForKey("members") as? [String]
                if (members != nil && members!.contains(uid)) {
                    print(trip.value.objectForKey("name") as! String)

                    let name = trip.value.objectForKey("name") as! String
                    let leaders = trip.value.objectForKey("leaders") as! [String]
                    let maxMembers = trip.value.objectForKey("maxMembers") as! Int
                    let cost = trip.value.objectForKey("cost") as! Int
                    let tags = trip.value.objectForKey("tags") as! [String]
                    let lat = trip.value.objectForKey("lat") as! CGFloat
                    let long = trip.value.objectForKey("long") as! CGFloat
                    let description = trip.value.objectForKey("description") as! String
                    let startTime = trip.value.objectForKey("startTime") as! Double
                    let endTime = trip.value.objectForKey("endTime") as! Double
                    
                    trips.append(TripClass(name: name, leaders: leaders, maxMembers: maxMembers, cost: cost, tags: tags, lat: lat, long: long, members: members!, description: description, startTime: startTime, endTime: endTime))
                }
            }
            callback(trips: trips)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
}

// UIViewController
class HomeFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func logoutPressed(sender: AnyObject) {
        
        
    }
    
    var tripArr = [TripClass]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        
        navBar!.barTintColor = UIColor.darkGrayColor()
        navBar!.translucent = false;
        navBar!.tintColor = UIColor.whiteColor()
        navBar!.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.navigationItem.title = "Apex"
                
        TripClass.getTrips(myfunc)
        
        tableView.estimatedRowHeight = 188
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    func myfunc(trips: [TripClass]) {
        tripArr = trips
        print("reloading database")
        tableView.reloadData()
  
    }
    
    func iconMapping(tag:String) -> String {
        

        //used in change region
        let iconDict: [String:String] = [
            "Hiking" : "icon_hiking",
            "CnT" : "icon_cabin",
            "White Mountains" : "icon_WhiteMountains",
            "DMC" : "icon_DMC",
            "Climbing" : "icon_climbing",
            "Rumney" : "icon_Rumney",
            "Camping" : "icon_Camping" ]
        
        return iconDict[tag]!
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tripArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell

        let trip = tripArr[indexPath.section]
        
        
        cell.picture.image = UIImage(named: "picture_mountain_1")
        cell.title.text = trip.name
        cell.registration.text = trip.getRegistrationText()

        cell.descriptionText.numberOfLines = 0

        cell.descriptionText.text = trip.description
        
//        cell.descriptionText.text = "1\n2\n3"
        
        
        let startDate = NSDate(timeIntervalSince1970: trip.startTime)
        let startDateFormatter = NSDateFormatter()
        startDateFormatter.dateFormat = "EEE MMM, dd h:mm a"
        
        let endDate = NSDate(timeIntervalSince1970: trip.endTime)
        let endDateFormatter = NSDateFormatter()
        endDateFormatter.dateFormat = "h:mm a"
        
        cell.dateTime.text = startDateFormatter.stringFromDate(startDate) + " to " + endDateFormatter.stringFromDate(endDate)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return CGFloat.min }
        return 6
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.greenColor() //make the background color light blue
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mainSB: UIStoryboard = UIStoryboard(name: "Tabs", bundle: nil)
        let detailVC = mainSB.instantiateViewControllerWithIdentifier("Detail") as! DetailViewController
        detailVC.tripObj = tripArr[indexPath.section]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    
}
