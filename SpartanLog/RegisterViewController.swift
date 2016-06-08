//
//  RegisterViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/7/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

// MARK: - RegisterViewController

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        registerButton.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        
        checkValidRegistrationValues()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidRegistrationValues()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        registerButton.enabled = false
    }
    
    private func checkValidRegistrationValues() {
        // Disable the Save button if the text field is empty.
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        registerButton.enabled = !name.isEmpty && !email.isEmpty && !password.isEmpty
    }
    
    // MARK: Actions
    
    @IBAction func registerButtonPressed(sender: AnyObject) {
        
        self.stopActivityIndicator()
        
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        SpartanAPI.sharedInstance().register(name, email: email, password: password) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                
                } else {
                    self.registrationFailed()
                }
                
                self.startActivityIndicator()
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("AfterLoginTabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
    
    private func registrationFailed() {
        self.passwordTextField.text = ""
        self.registerButton.enabled = false
        self.registerButton.setTitle("Please try again", forState: .Disabled)
    }
    
    // MARK: Helper Functions
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}