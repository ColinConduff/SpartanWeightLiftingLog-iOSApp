//
//  LoginViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var loginButton: UIButton!
    
    var session: NSURLSession!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Actions
    
    @IBAction func loginPressed(sender: AnyObject) {
        SpartanAPI.sharedInstance().login(nil, email: nil) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                }
            }
        }
    }
    
    private func completeLogin() {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("AfterLoginTabBarController") as! UITabBarController
        presentViewController(controller, animated: true, completion: nil)
    }
}