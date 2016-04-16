//
//  CreateAccount.swift
//  Apex
//
//  Created by Yining Chen on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit
import SCLAlertView
import Firebase

class CreateAccount: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dashTextField: UITextField!
    
    var myRootRef = Firebase(url:"https://apexdatabase.firebaseio.com")
    let showTabsFromSignup = "showTabsFromSignup"
    let backToLogin = "backToLogin"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        myRootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier(self.showTabsFromSignup, sender: nil)
            }
        }
    }
    
    @IBAction func backClick(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signupClick(sender: UIButton) {
        let emailin:NSString = emailTextField.text! as NSString
        let passwordin:NSString = passwordTextField.text! as NSString
        let dashin:NSString = dashTextField.text! as NSString
        let namein:NSString = nameTextField.text! as NSString

        if (emailin.isEqualToString("")) {
            SCLAlertView().showError("Sign Up Failed", subTitle: "Please enter an email and try again")
        } else if (passwordin.isEqualToString("")) {
            SCLAlertView().showError("Sign Up Failed", subTitle: "Please enter a password and try again")
        } else if (dashin.isEqualToString("")) {
            SCLAlertView().showError("Sign Up Failed", subTitle: "Please enter your valid DASH number and try again")
        } else if ( namein.isEqualToString("")) {
            SCLAlertView().showError("Sign Up Failed", subTitle: "Please enter your full name and try again")
        } else {
            // Create user
            myRootRef.createUser(emailin as String, password: passwordin as String, withValueCompletionBlock: { error, result in
                                    if error != nil {
                                        // There was an error creating the account
                                        SCLAlertView().showError("Sign Up Failed", subTitle: "Please try again")
                                    } else {
                                        let uid = result["uid"] as? String
                                        print("Successfully created user account with uid: \(uid)")
                                        // Create user node
                                        // Create a reference to the users root node
                                        let userRootRef = Firebase(url:"https://apexdatabase.firebaseio.com/users")
                                        let userRef = userRootRef.childByAppendingPath(uid)
                                        let userValue = ["name": namein as String, "dash": dashin as String]
                                        userRef.updateChildValues(userValue);
                             
                                        self.myRootRef.authUser(emailin as String, password: passwordin as String,
                                            withCompletionBlock: { (error, auth) in
                                                if error != nil {
                                                    SCLAlertView().showError("Log In Failed", subTitle: "Please try logging in again from the home page")
                                                }
                                                else {
                                                    print(auth.uid)
                                                }
                                                
                                        })
                                    }
            })
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

