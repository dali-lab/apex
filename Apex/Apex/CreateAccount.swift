//
//  CreateAccount.swift
//  Apex
//
//  Created by Yining Chen on 4/16/16.
//  Copyright © 2016 DALI. All rights reserved.
//

import UIKit
import Firebase

class CreateAccount: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dashTextField: UITextField!
    
    var myRootRef = Firebase(url:"https://apexdatabase.firebaseio.com")
    let showTabsFromSignup = "showTabsFromSignup"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func signupClick(sender: UIButton) {
        let emailin:NSString = emailTextField.text! as NSString
        let passwordin:NSString = passwordTextField.text! as NSString
        let dashin:NSString = dashTextField.text! as NSString
        let namein:NSString = nameTextField.text! as NSString
        
        if (emailin.isEqualToString("") || passwordin.isEqualToString("") || dashin.isEqualToString("") || namein.isEqualToString("")) {
            
            let alertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Please fill in all textfields"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
            
        } else {
            // Create user
            myRootRef.createUser(emailin as String, password: passwordin as String, withValueCompletionBlock: { error, result in
                                    if error != nil {
                                        // There was an error creating the account
                                        let alertView:UIAlertView = UIAlertView()
                                        alertView.title = "Sign up Failed!"
                                        alertView.message = "Please enter valid email address"
                                        alertView.delegate = self
                                        alertView.addButtonWithTitle("OK")
                                        alertView.show()
                                    } else {
                                        let uid = result["uid"] as? String
                                        print("Successfully created user account with uid: \(uid)")
                                    }
            })

            myRootRef.authUser(emailin as String, password: passwordin as String,
                         withCompletionBlock: { (error, auth) in
                            
            })
            
            // Create user node
            // Create a reference to the users root node
            let userRootRef = Firebase(url:"https://apexdatabase.firebaseio.com/users")
            let userRef = userRootRef.childByAutoId()
            let userValue = ["name": namein as String, "dash": dashin as String]
            userRef.updateChildValues(userValue);
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        myRootRef.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier(self.showTabsFromSignup, sender: nil)
            }
        }
    }
}

