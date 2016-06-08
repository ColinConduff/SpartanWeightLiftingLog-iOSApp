//
//  WorkoutViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class WorkoutDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var workoutNameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `workoutTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new workout.
     */
    var workout: Workout?
    var updating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        workoutNameTextField.delegate = self
        
        // Set up views if editing an existing workout.
        if let workout = workout {
            updating = true
            navigationItem.title = workout.name
            workoutNameTextField.text   = workout.name
        }
        
        // Enable the Save button only if the text field has a valid workout name.
        checkValidWorkoutName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidWorkoutName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidWorkoutName() {
        // Disable the Save button if the text field is empty.
        let text = workoutNameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
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
            if let workout = workout {
                id = workout.id
            }
            let name = workoutNameTextField.text ?? ""
            
            // Set the workout to be passed to workoutListTableViewController after the unwind segue.
            workout = Workout(id: id, name: name)
        }
        
        if segue.identifier == Const.Storyboard.ShowAttachExerciseTable {
            var destinationvc = segue.destinationViewController
            if let navcon = destinationvc as? UINavigationController {
                destinationvc = navcon.visibleViewController ?? destinationvc
            }
            
            if let attachExerciseTableViewController = destinationvc as? AttachExerciseTableViewController {
                attachExerciseTableViewController.workout = workout
            }
        }
    }
}
