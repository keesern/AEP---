//
//  SignUpViewController.swift
//  MySampleApp
//
//  Created by Xiakan Xu on 2016/10/28.
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
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
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
        else if(!validEmailAddress(newEmailAddressField.text!)){
            self.displayError("Sorry!", info: "Only Honda Email Address is acceptable. Please contact your instructor for more infomation.")
            
            //  TODO for future group.
            /*  This feature is hard coded at this time.
                However, sponsors wish to manage valid email address manually on the webside.
                So please move this feature to the server side and add another feature, 
                which allowed instructors to decide what kind of email address is acceptable.
             */
        }
        else if(newFirstNameField.text == ""){
            self.displayError("", info: "Please enter your first name in English!")
        }
        else if(newLastNameField == ""){
            self.displayError("", info: "Please enter your last name in English!")
        }
        else if(newPasswordField.text == ""){
            self.displayError("", info: "Please enter your Password")
        }
        else{
            var newAttributes = [AWSCognitoIdentityUserAttributeType]()
            let emailAddress = AWSCognitoIdentityUserAttributeType()
            let lastname = AWSCognitoIdentityUserAttributeType()
            let firstname = AWSCognitoIdentityUserAttributeType()
            
            emailAddress.name = "email"
            lastname.name = "custom:Lastname"
            firstname.name = "custom:Firstname"
            
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
                            
                            self.displayError("Unverified Account", info: "Please wait for your instructor to verfiy your account.")
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
    
    @IBAction func backToLogin(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue(),{
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    
    // This feature is hard coded, but expected to be realized on the server in the future.
    func validEmailAddress(newEmail: String)-> Bool {
        var valid:Bool = false;
        
        if newEmail.lowercaseString.rangeOfString("@ham.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hna.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@htm.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hmin.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hcm.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@ega.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hsc.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@honda-aero.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hdm.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hma.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hpg.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hpe.honda.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@oh.hra.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@mx.hra.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@hm.honda.co.jp") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@ahm.honda.com") != nil {
            valid = true;
        }
            // For testing purpose, gmail and buckeyemail is currently allowed.
        else if newEmail.lowercaseString.rangeOfString("@gmail.com") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@osu.edu") != nil {
            valid = true;
        }
        else if newEmail.lowercaseString.rangeOfString("@buckeyemail.osu.edu") != nil {
            valid = true;
        }

        return valid;
    }
    
    func displayError(title: String, info:String) {
        // Handle Create Account action for custom sign-in here.
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: "Label for custom sign-in dialog."), message: NSLocalizedString(info, comment: "Sign-in message structure for custom sign-in stub."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: "Label to complete stubbed custom sign-in."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
