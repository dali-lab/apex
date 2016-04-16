//
//  LoginViewController.swift
//  Apex
//
//  Created by Jason Feng on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import Firebase
import UIKit
import SCLAlertView

class LoginViewController: UIViewController {

    let ref = Firebase(url: "https://apexdatabase.firebaseio.com")
    let showHome = "showHome"
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref.unauth()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onClickLogin(sender: AnyObject) {
        ref.authUser(email.text, password: password.text,
                     withCompletionBlock: { (error, auth) in
                        if error != nil {
                            SCLAlertView().showError("Failed to log in", subTitle: "Please enter your correct email or password and try again.")
                        }
                        else {
                            
                        }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier(self.showHome, sender: nil)
            }
        }
    }

}
