//
//  DetailViewController.swift
//  Apex
//
//  Created by ArminM on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit

import ImageSlideshow
import MapKit
import Firebase



class DetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    var inTrip = false
    
    @IBOutlet weak var leader1Image: UIImageView!
    @IBOutlet weak var leader1Label: UILabel!
    @IBOutlet weak var leader2Image: UIImageView!
    @IBOutlet weak var leader2Label: UILabel!
    @IBOutlet weak var leader3Image: UIImageView!
    @IBOutlet weak var leader3Label: UILabel!
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    let regionRadius: CLLocationDistance = 10000
    
    var tripObj = TripClass(name: "", leaders: [], maxMembers: 0, cost: 0, tags: [], lat: 0.0, long: 0.0, members: [], description: "", startTime: 0, endTime: 0)
    
    func imageMapping(leader: String) -> String {
 
            //used in change region
            let iconDict: [String:String] = [
                "Pat Xu" : "person_pat",
                "Jason Feng" : "person_jason",
                "Armin Mahban" : "person_armin",
                "Yining Chen" : "person_yining"]
            
            return iconDict[leader]!

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripTitle.text = tripObj.name
        leader1Label.text = tripObj.leaders[0]
        leader1Image.image = UIImage(named: imageMapping(tripObj.leaders[0]))
        
        leader1Image.layer.cornerRadius = leader1Image.frame.size.width / 2
        leader1Image.clipsToBounds = true
        leader1Image.layer.borderWidth = 3.0
        leader1Image.layer.borderColor = UIColor.darkGrayColor().CGColor
        leader2Image.layer.cornerRadius = leader3Image.frame.size.width / 2
        leader2Image.clipsToBounds = true
        leader2Image.layer.borderWidth = 3.0
        leader2Image.layer.borderColor = UIColor.darkGrayColor().CGColor
        leader3Image.layer.cornerRadius = leader1Image.frame.size.width / 2
        leader3Image.clipsToBounds = true
        leader3Image.layer.borderWidth = 3.0
        leader3Image.layer.borderColor = UIColor.darkGrayColor().CGColor

        
        
        if tripObj.leaders.count > 1 {
            leader2Label.text = tripObj.leaders[1]
            leader2Image.image = UIImage(named: imageMapping(tripObj.leaders[1]))
        } else {
            leader2Label.hidden = true
            leader2Image.hidden = true
        }
        if tripObj.leaders.count > 2 {
            leader3Label.text = tripObj.leaders[2]
            leader3Image.image = UIImage(named: imageMapping(tripObj.leaders[2]))
        } else {
            leader3Label.hidden = true
            leader3Image.hidden = true
        }
        
        

        updateDescription()
        
        let fixedWidth = textDescription.frame.size.width
        textDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textDescription.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textDescription.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textDescription.frame = newFrame
        textDescription.scrollEnabled = false
        

        
        let initialLocation = CLLocation(latitude: Double(tripObj.lat), longitude: Double(tripObj.long))
        dispatch_async(dispatch_get_main_queue()) {
            self.centerMapOnLocation(initialLocation)
            let myHomePin = MKPointAnnotation()
            myHomePin.coordinate = initialLocation.coordinate
            myHomePin.title = self.tripObj.name
            self.mapView.addAnnotation(myHomePin)
        }
//        mapView.userInteractionEnabled = false
        
        setUpSlideShow()

        // Do any additional setup after loading the view.
        
        updateJoinButton()
    }
    
    @IBAction func joinGroup(sender: AnyObject) {
//        let ref = Firebase(url: "https://apexdatabase.firebaseio.com/")
//        ref.unauth()
        if inTrip { // attempt to join group
            print("joining")
            if tripObj.joinTrip(UserManager.uid) { // joined
                updateDescription()
            } else {
                
            }
        } else { // leave group
            print("leaving")
            if tripObj.leaveTrip(UserManager.uid) { // left
                updateDescription()
            } else {
                
            }
        }
    }
    
    func updateJoinButton() {
        if tripObj.members.contains(UserManager.uid) { // already in group
            joinButton.titleLabel?.text = "Leave"
            inTrip = true
        } else {
            joinButton.titleLabel?.text = "Join"
            inTrip = false
        }
    }
    
    func updateDescription() {
        textDescription.text = tripObj.getRegistrationText() + "\n\n" + tripObj.description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSlideShow() {
        slideshow.backgroundColor = UIColor.whiteColor()
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.InsideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        slideshow.pageControl.pageIndicatorTintColor = UIColor.whiteColor();
        slideshow.contentScaleMode = .ScaleAspectFill
        
        slideshow.setImageInputs([AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/flysch-rocks-barrika-beach-sunset-58426273.jpg")!, AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/man-surfboard-beautiful-foggy-beach-boy-running-golden-sunrise-daytona-florida-58532550.jpg")!, AlamofireSource(urlString: "https://thumbs.dreamstime.com/z/woman-putting-mask-her-face-black-cloak-sitting-ground-58291716.jpg")!])
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.click))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    func click() {
        let ctr = FullScreenSlideshowViewController()
        ctr.pageSelected = {(page: Int) in
            self.slideshow.setScrollViewPage(page, animated: false)
        }
        
        ctr.initialPage = slideshow.scrollViewPage
        ctr.inputs = slideshow.images
        self.transitionDelegate = ZoomAnimatedTransitioningDelegate(slideshowView: slideshow);
        ctr.transitioningDelegate = self.transitionDelegate!
        self.presentViewController(ctr, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // add annotation to the map
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            anView.image = UIImage(named:"xaxas")
            anView!.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        return anView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}
