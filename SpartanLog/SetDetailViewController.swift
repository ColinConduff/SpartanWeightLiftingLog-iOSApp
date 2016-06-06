//
//  SetDetailViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SetDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var repetitionsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `setTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new set.
     */
    var set: Set?
    var updating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        repetitionsTextField.delegate = self
        weightTextField.delegate = self
        
        // Set up views if editing an existing set.
        if let set = set {
            updating = true
            navigationItem.title = "Edit Set"
            repetitionsTextField.text = String(set.repetitions)
            weightTextField.text = String(set.weight)
        }
        
        // Enable the Save button only if the text field has a valid Set name.
        checkValidSet()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidSet()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidSet() {
        // Disable the Save button if the text field is empty.
        let reps = Int(repetitionsTextField.text!)
        let weight = Double(weightTextField.text!)
        
        if reps > 0 && weight >= 0 {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        
        if !updating {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            var id: Int?
            if let set = set {
                id = set.id
            }
            let repetitions = Int(repetitionsTextField.text!)
            let weight = Double(weightTextField.text!)
            
            // Set the set to be passed to setListTableViewController after the unwind segue.
            set = Set(id: id, repetitions: repetitions!, weight:weight!)
        }
    }
    
    // MARK: Delete 
    
    
    @IBAction func showDeleteButton(sender: UIBarButtonItem) {
        if updating {
            let deleteButton = view.viewWithTag(1) as? UIButton
            deleteButton?.hidden = false
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func sendDelete(sender: UIButton) {
        deleteSet(set!)
    }
    
    func deleteSet(set: Set) {
        SpartanAPI.sharedInstance().deleteSet(set) {
            (sets, error) in
            if let error = error {
                print(error)
                
            } else {
                performUIUpdatesOnMain {
                    if !self.updating {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.navigationController!.popViewControllerAnimated(true)
                    }
                }
            }
        }
    }
}
