//
//  SignInViewController.swift
//  MySampleApp
//  Modified By Xiakan Xu on Fall 2016
//
//  Source code generated from template: aws-my-sample-app-ios-swift v0.4
//
//

import UIKit
import AWSMobileHubHelper
import AWSCognitoIdentityProvider

class SignInViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var anchorView: UIView!

    @IBOutlet weak var customLogin: UIButton!
    @IBOutlet weak var customCreateAccountButton: UIButton!
    @IBOutlet weak var customForgotPasswordButton: UIButton!
    //Editing Point
    //@IBOutlet weak var customUserIdField: UITextField!
    @IBOutlet weak var customEmailAddressField: UITextField!
    @IBOutlet weak var customPasswordField: UITextField!
    @IBOutlet weak var leftHorizontalBar: UIView!
    @IBOutlet weak var rightHorizontalBar: UIView!
    @IBOutlet weak var orSignInWithLabel: UIView!
    var keyboardHeight:CGFloat = 0;
    var defualtScreenHeight:CGFloat = 0;
    
    
    var didSignInObserver: AnyObject!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        customLogin.layer.cornerRadius = 4

         print("Sign In Loading.")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

        
            didSignInObserver =  NSNotificationCenter.defaultCenter().addObserverForName(AWSIdentityManagerDidSignInNotification,
                object: AWSIdentityManager.defaultIdentityManager(),
                queue: NSOperationQueue.mainQueue(),
                usingBlock: {(note: NSNotification) -> Void in
                    // perform successful login actions here
            })
        
        //Keyboard return
        self.customEmailAddressField.delegate = self;
        self.customPasswordField.delegate = self;
        
        customEmailAddressField.tag = 0
        customPasswordField.tag = 1
        
        defualtScreenHeight = self.view.frame.origin.y;
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(didSignInObserver)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        self.keyboardHeight = keyboardRectangle.height
        self.view.frame.origin.y = self.defualtScreenHeight - self.keyboardHeight
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = self.defualtScreenHeight;
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        self.view.frame.origin.y = self.defualtScreenHeight;
    }
    
    /*
    func textFieldDidBeginEditing(textField: UITextField) {
            self.view.frame.origin.y -= self.keyboardHeight
            self.view.frame.size.height += self.keyboardHeight
    }
    
    func textFieldDidEndEditing(textField: UITextField){

            //Finish editing username
            self.view.frame.origin.y += self.keyboardHeight
            self.view.frame.size.height -= self.keyboardHeight

    }
 */
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if (textField.tag == 0){
            // Username entered and return pressed
            // Go to edit PasswordTextField
            if let nextField = textField.superview?.viewWithTag(1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                print("Warning: Password Text Field Not Found!")
                textField.resignFirstResponder()
            }
        }
        else if(textField.tag == 1){
            textField.resignFirstResponder()
            //After the password entered, press return has the same effect as login
            //TODO
            //handleCustomLogin()
            self.handleCustomLogin(nil)
        }
        return false
    }
    
    func dimissController() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Utility Methods

    @IBAction func createNewProfile(sender: UIButton) {
       /* let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUp")
        self.navigationController!.pushViewController(viewController, animated: true)
 */
        
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SignUp") as UIViewController
        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func handleLoginWithSignInProvider(signInProvider: AWSSignInProvider) {
        
        AWSIdentityManager.defaultIdentityManager().loginWithSignInProvider(signInProvider, completionHandler: {(result: AnyObject?, error: NSError?) -> Void in
            // If no error reported by SignInProvider, discard the sign-in view controller.
            if error == nil {
                dispatch_async(dispatch_get_main_queue(),{
                        self.dismissViewControllerAnimated(true, completion: nil)
                })
                
            }
            else {
                dispatch_async(dispatch_get_main_queue(),{
                    if(error?.code == 16){
                        self.displayError("", info: "Incorrect username or password")
                    }
                    else{
                        self.displayError("", info: "Incorrect username or password")
                        //self.displayError("Error", info:error.debugDescription)
                    }
                    
                })
            }
        })
    }

    func showErrorDialog(loginProviderName: String, withError error: NSError) {
         print("\(loginProviderName) failed to sign in w/ error: \(error)")
        let alertController = UIAlertController(title: NSLocalizedString("Sign-in Provider Sign-In Error", comment: "Sign-in error for sign-in failure."), message: NSLocalizedString("\(loginProviderName) failed to sign in w/ error: \(error)", comment: "Sign-in message structure for sign-in failure."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Label to cancel sign-in failure."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    // MARK: - IBActions
    
    
    //var passwordAuthenticationCompletion: AWSTaskCompletionSource = AWSTaskCompletionSource.init()
    @IBAction func handleCustomLogin(sender: UIButton?) {
        
        self.view.frame.origin.y = self.defualtScreenHeight;
        
        if(self.customEmailAddressField.text == ""){
            self.displayError("", info: "Please enter email address!")
        }
        else if(self.customPasswordField.text == ""){
            self.displayError("", info: "Please enter password!")
        }
        if (customEmailAddressField.text != "") && (customPasswordField.text != "") {
            
            let customSignInProvider = AWSCUPIdPSignInProvider.sharedInstance
            
            // Push email address and password to AWSCUPIdPSignInProvider

            customSignInProvider.customUserEmailAddress = customEmailAddressField.text
            customSignInProvider.customPasswordField = customPasswordField.text
            
            handleLoginWithSignInProvider(customSignInProvider)
        }
    }
 
    
    func displayError(title: String, info:String) {
        // Handle Create Account action for custom sign-in here.
        let alertController = UIAlertController(title: NSLocalizedString(title, comment: "Label for custom sign-in dialog."), message: NSLocalizedString(info, comment: "Sign-in message structure for custom sign-in stub."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: "Label to complete stubbed custom sign-in."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func handleCustomForgotPassword() {
        // Handle Forgot Password action for custom sign-in here.
        let alertController = UIAlertController(title: NSLocalizedString("Custom Sign-In Demo", comment: "Label for custom sign-in dialog."), message: NSLocalizedString("This is just a demo of custom sign-in Forgot Password button.", comment: "Sign-in message structure for custom sign-in stub."), preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: NSLocalizedString("Done", comment: "Label to complete stubbed custom sign-in."), style: .Cancel, handler: nil)
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
 */
    
    func anchorViewForFacebook() -> UIView {
            return orSignInWithLabel
    }
}

class FeatureDescriptionViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Back", style: .Plain, target: nil, action: nil)
    }
}
