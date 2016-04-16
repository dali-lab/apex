//
//  HomeFeedViewController.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit

class HomeFeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = self.navigationController?.navigationBar
        
        navBar!.barTintColor = UIColor.darkGrayColor()
        navBar!.translucent = false;
        navBar!.tintColor = UIColor.whiteColor()
        navBar!.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!, NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.navigationItem.title = "Apex"
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell", forIndexPath: indexPath) as! FeedTableViewCell
        
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
            performSegueWithIdentifier("toDetail2", sender: self)
    }

    
}
