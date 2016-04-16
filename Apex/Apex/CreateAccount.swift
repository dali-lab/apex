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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create a reference to a Firebase location
        var myRootRef = Firebase(url:"https://apexdatabase.firebaseio.com")
        
    }

    @IBAction func signupButton(sender: UIButton) {
        var emailin:NSString = emailTextField.text! as NSString
        var passwordin:NSString = passwordTextField.text! as NSString
        
        var alertView:UIAlertView = UIAlertView()
        alertView.title = "Sign up Failed!"
        alertView.message = emailin as String
        alertView.delegate = self
        alertView.addButtonWithTitle(passwordin as String)
        alertView.show()
        
        if (emailin.isEqualToString("") || passwordin.isEqualToString("") ) {
            
            alertView = UIAlertView()
            alertView.title = "Sign up Failed!"
            alertView.message = "Please enter Email and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            // Create a reference to a Firebase location
            var myRootRef = Firebase(url:"https://apexdatabase.firebaseio.com")
            
            // Create user
            myRootRef.createUser(emailin as String, password: passwordin as String,
                                 withValueCompletionBlock: { error, result in
                                    if error != nil {
                                        // There was an error creating the account
                                        print(error)
                                    } else {
                                        let uid = result["uid"] as? String
                                        print("Successfully created user account with uid: \(uid)")
                                    }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

