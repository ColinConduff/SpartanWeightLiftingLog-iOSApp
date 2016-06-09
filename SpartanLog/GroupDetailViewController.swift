//
//  GroupDetailViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var AttachWorkoutsContainerView: UIView!
    
    /*
     This value is either passed by `groupTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new group.
     */
    var group: Group?
    var updating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AttachWorkoutsContainerView.hidden = true
        
        // Handle the text field’s user input through delegate callbacks.
        groupNameTextField.delegate = self
        
        // Set up views if editing an existing group.
        if let group = group {
            updating = true
            AttachWorkoutsContainerView.hidden = false
            
            navigationItem.title = group.name
            groupNameTextField.text   = group.name
        }
        
        // Enable the Save button only if the text field has a valid Group name.
        checkValidGroupName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidGroupName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidGroupName() {
        // Disable the Save button if the text field is empty.
        let text = groupNameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: Navigation
    
    @IBAction func back(sender: UIBarButtonItem) {
        
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
            if let group = group {
                id = group.id
            }
            let name = groupNameTextField.text ?? ""
            
            // Set the group to be passed to groupListTableViewController after the unwind segue.
            group = Group(id: id, name: name)
        }
    
        if segue.identifier == Const.Storyboard.ShowAttachWorkoutTable {
            var destinationvc = segue.destinationViewController
            if let navcon = destinationvc as? UINavigationController {
                destinationvc = navcon.visibleViewController ?? destinationvc
            }
            
            if let attachWorkoutTableViewController = destinationvc as? AttachWorkoutTableViewController {
                attachWorkoutTableViewController.group = group
            }
        }
    }
}
