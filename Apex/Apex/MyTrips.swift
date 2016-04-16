//
//  MyTrips.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit
import Firebase

class MyTrips: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tripArr = [TripClass]()

    @IBAction func logoutPressed(sender: AnyObject) {
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        
        navBar!.barTintColor = UIColor.darkGrayColor()
        navBar!.translucent = false;
        navBar!.tintColor = UIColor.whiteColor()
        navBar!.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.navigationItem.title = "Apex"
        
        TripClass.getMyTrips(myfunc)
        
        
        
        
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
        
        if let icon = iconDict[tag] {
            return icon
        } else { return "icon_hiking" }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MyTripsCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        let trip = tripArr[indexPath.section]
        
        
        cell.picture.image = UIImage(named: "picture_mountain_\(indexPath.section + 1)")
        cell.title.text = trip.name
        if trip.getRemainingSpots() == 0 { // remaining
            cell.registration.text = "Trip is full"
        } else {
            cell.registration.text = String(trip.getRemainingSpots()) + " " + (trip.getRemainingSpots() == 0 ? "spot": "spots") + " remaining"
        }
        
        if trip.cost == 0 { //cost
            cell.registration.text = cell.registration.text! + ", Free"
        } else {
            cell.registration.text = cell.registration.text! + ", $" + String(trip.cost)
        }
        let iconMapped = iconMapping(tripArr[indexPath.section].tags[0])
        cell.icon.image = UIImage(named: iconMapped)
        
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
    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 { return CGFloat.min }
//        return 6
//    }
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.min
//    }
    
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
