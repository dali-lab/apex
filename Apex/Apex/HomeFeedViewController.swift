//
//  HomeFeedViewController.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit
import Firebase

class TripClass {
    
    static let ref = Firebase(url: "https://apexdatabase.firebaseio.com/trips")
    
    // a Trip in the database MUST have these fields
    var name: String = ""
    var leaders: [String] = []
    var maxMembers: Int = 0
    var cost: Int = 0
    var tags: [String] = []
    var lat: CGFloat = 0.0
    var long: CGFloat = 0.0
    
    // these fields are optional
    var members: [String] = []

    
    
    init(name: String, leaders: [String], maxMembers: Int, cost: Int, tags: [String], lat: CGFloat, long: CGFloat, members: [String]) {
        self.name = name
        self.leaders = leaders
        self.maxMembers = maxMembers
        self.cost = cost
        self.tags = tags
        self.lat = lat
        self.long = long
        self.members = members
    }
    
    class func getTrips(callback:(trips: [TripClass]) -> Void) {
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
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
                
                trips.append(TripClass(name: name, leaders: leaders, maxMembers: maxMembers, cost: cost, tags: tags, lat: lat, long: long, members: members!))
            }
            callback(trips: trips)
            }, withCancelBlock: { error in
                print(error.description)
        })
    }

}


class HomeFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
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
        
        
    }


    func myfunc(trips: [TripClass]) {
        print(trips)
        
        tripArr = trips
        print("reloading database")
        tableView.reloadData()
        
        
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
        
        print ("cell")
        
        cell.picture.image = UIImage(named: "picture_mountain_1")
        
//        cell.picture.contentMode = .
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 208;//Choose your custom row height
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
        self.navigationController!.pushViewController(detailVC, animated: true)
        
        
    }

    
}
