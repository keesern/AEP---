//
//  SignUpViewController.swift
//  MySampleApp
//
//  Created by xuxiak on 2016/10/28.
//
//


import UIKit
import AWSCore
import AWSMobileHubHelper
import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController {
    @IBOutlet weak var anchorView: UIView!
    
    @IBOutlet weak var newEmailAddressField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var newFirstNameField: UITextField!
    @IBOutlet weak var newLastNameField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    
    var userPool: AWSCognitoIdentityUserPool?
    var user: AWSCognitoIdentityUser?
    
    
    
    var didSignUpObserver: AnyObject!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Sign In Loading.")
        self.userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
        

        didSignUpObserver =  NSNotificationCenter.defaultCenter().addObserverForName(AWSIdentityManagerDidSignInNotification,
                                                                                     object: AWSIdentityManager.defaultIdentityManager(),
                                                                                     queue: NSOperationQueue.mainQueue(),
                                                                                     usingBlock: {(note: NSNotification) -> Void in
                                                                                        // perform successful login actions here
        })
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(didSignUpObserver)
    }
    
    func dimissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Utility Methods
    @IBAction func handleSignUpPressed(sender: UIButton) {
        print("Sign Up Button Pressed")
        if(newEmailAddressField.text == ""){
            self.displayError("", info: "Please enter your email address!")
        }
        else if(newFirstNameField.text == ""){
            self.displayError("", info: "Please enter your first name in English!")
        }
        else if(newLastNameField == ""){
            self.displayError("", info: "Please enter your last name in English!")
        }
        else if(newPasswordField.text == ""){
            self.displayError("", info: "Please enter your name in Kanji!")
        }
        else{
            var newAttributes = [AWSCognitoIdentityUserAttributeType]()
            let emailAddress = AWSCognitoIdentityUserAttributeType()
            let lastname = AWSCognitoIdentityUserAttributeType()
            let firstname = AWSCognitoIdentityUserAttributeType()
            
            emailAddress.name = "email"
            lastname.name = "custom:LastName"
            firstname.name = "custom:FirstName"
            
            emailAddress.value = newEmailAddressField.text
            lastname.value = newLastNameField.text
            firstname.value = newFirstNameField.text
            
            newAttributes.append(emailAddress)
            newAttributes.append(lastname)
            newAttributes.append(firstname)
            
            print("Check Point 1")
            // Username is required and hardcoded right now
            self.userPool?.signUp(newEmailAddressField.text!, password: newPasswordField.text!, userAttributes: newAttributes, validationData: nil).continueWithBlock{ (task) in
                dispatch_async(dispatch_get_main_queue()) {
                    
                    print("Check Point 2")
                    if task.error != nil {  // some sort of error
                        let alert = UIAlertController(title: "", message: task.error?.userInfo["message"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                        NSLog("Domain: " + (task.error?.domain)! + " Code: \(task.error?.code)")
                        NSLog(task.error?.userInfo["message"] as! String)
                        
                        print("Check Point 3")
                    }
                    else {
                        print("Check Point 4")
                        let response: AWSCognitoIdentityUserPoolSignUpResponse = task.result as! AWSCognitoIdentityUserPoolSignUpResponse
                        // NSLog("AWSCognitoIdentityUserPoolSignUpResponse: \(response)")
                        self.user = response.user
                        
                        if (response.userConfirmed != AWSCognitoIdentityUserStatus.Confirmed.rawValue) { // not confirmed
                            
                            self.displayError("Unconfirmed Account", info: "Confirm your account in Cognito")
                            
                            //self.sentTo = response.codeDeliveryDetails?.destination
                            //self.performSegueWithIdentifier("confirmSignup", sender: sender)
                        } else { // user is confirmed - can it happen?
                            self.navigationController?.popToRootViewControllerAnimated(true) // back to login
                        }
                    }
                }
                return nil
            }
        }

    }
    
    func displayError(title: String, info:String) {
        // Handle Create Account action for custom sign-in here.
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: "Label for custom sign-in dialog."), message: NSLocalizedString(info, comment: "Sign-in message structure for custom sign-in stub."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: "Label to complete stubbed custom sign-in."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
