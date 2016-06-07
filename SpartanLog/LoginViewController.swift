//
//  LoginViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

// MARK: - LoginViewController

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        
        checkValidLoginValues()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidLoginValues()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        loginButton.enabled = false
    }
    
    func checkValidLoginValues() {
        // Disable the Save button if the text field is empty.
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginButton.enabled = !email.isEmpty && !password.isEmpty
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SpartanAPI.sharedInstance().login(email, password: password) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                    
                } else {
                    self.loginFailed()
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("AfterLoginTabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func loginFailed() {
        self.passwordTextField.text = ""
        self.loginButton.enabled = false
        self.loginButton.setTitle("Please try again", forState: .Disabled)
    }
}