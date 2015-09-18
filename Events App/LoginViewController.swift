//
//  LoginViewController.swift
//  Events App
//
//  Created by Gladwin Dosunmu on 17/09/2015.
//  Copyright © 2015 Gladwin Dosunmu. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    var loginForm = false
    
    @IBOutlet var loginTitleLabel: UILabel!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var changeFormButton: UIButton!
    
    @IBAction func changeFormButtonAction(sender: AnyObject) {
        
        if loginForm == true {
            
            loginForm = false
            changeFormButton.setTitle("Sign Up", forState: .Normal)
            email.hidden = true
            loginTitleLabel.text = "Login"
            
        } else {
            
            loginForm = true
            changeFormButton.setTitle("Login", forState: .Normal)
            email.hidden = false
            loginTitleLabel.text = "Sign Up"
            
        }
        
    }
    @IBAction func submit(sender: AnyObject) {
        
        if loginForm == true {
            
            self.signUpMethod()
            
        } else {
            
            self.loginMethod()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        email.hidden = true
    }
    
    func signUpMethod() {
        
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        user.email = email.text
        
        var emailAddress = email.text!.lowercaseString
        
        user.signUpInBackgroundWithBlock { (succeeded, error) -> Void in
            
            if let error = error {
                
                let errorString = error.userInfo["error"] as? NSString
                
            } else {
                
                self.checkUser()

            }
        }
    }
    
    func loginMethod() {
        
        PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) { (user, error) -> Void in
            
            if user != nil {
                
                self.checkUser()
                
            } else {
                
                // Login failed
                
            }
        }
    }
    
    func checkUser() {
        
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            
            print("Name \(PFUser.currentUser()!.username)")
            
            let alertController = UIAlertController(title: "Welcome", message: "You are now logged in", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                
                let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! MasterViewController
                
                self.navigationController?.pushViewController(homeViewController, animated: true)
                
                
                
            }))
            
            presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
