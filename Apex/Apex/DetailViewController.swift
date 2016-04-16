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


class DetailViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tripTitle: UILabel!
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var leader1Image: UIImageView!
    @IBOutlet weak var leader1Label: UILabel!
    @IBOutlet weak var leader2Image: UIImageView!
    @IBOutlet weak var leader2Label: UILabel!
    @IBOutlet weak var leader3Image: UIImageView!
    @IBOutlet weak var leader3Label: UILabel!
    
    @IBOutlet weak var tripDescription: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    var transitionDelegate: ZoomAnimatedTransitioningDelegate?
    let regionRadius: CLLocationDistance = 1000
    
    var tripObj = TripClass(name: "", leaders: [], maxMembers: 0, cost: 0, tags: [], lat: 0.0, long: 0.0, members: [], description: "", startTime: 0, endTime: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        

        dispatch_async(dispatch_get_main_queue()) {
            self.centerMapOnLocation(initialLocation)
        }
        
        mapView.userInteractionEnabled = false
        
        setUpSlideShow()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpSlideShow() {
        slideshow.backgroundColor = UIColor.whiteColor()
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.UnderScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGrayColor();
        slideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor();
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
