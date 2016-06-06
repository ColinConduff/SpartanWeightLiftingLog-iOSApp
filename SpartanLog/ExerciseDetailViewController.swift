//
//  ExerciseDetailViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class ExerciseDetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var bodyRegionPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `exerciseTableViewController` in `prepareForSegue(_:sender:)`
     or constructed as part of adding a new exercise.
     */
    var exercise: Exercise?
    var bodyRegions = [
        "Chest", "Triceps", "Shoulders", "Back", "Biceps", "Forearms", "Legs", "Fullbody"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        exerciseNameTextField.delegate = self
        bodyRegionPicker.delegate = self
        bodyRegionPicker.dataSource = self
        
        // Set up views if editing an existing exercise.
        if let exercise = exercise {
            navigationItem.title = exercise.name
            exerciseNameTextField.text   = exercise.name
            let row = bodyRegions.indexOf(exercise.bodyRegion)
            if let row = row {
                bodyRegionPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
        
        // Enable the Save button only if the text field has a valid exercise name.
        checkValidExerciseName()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidExerciseName()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidExerciseName() {
        // Disable the Save button if the text field is empty.
        let text = exerciseNameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: UIPicker
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bodyRegions.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bodyRegions[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        checkValidExerciseName()
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddExerciseMode = presentingViewController is UINavigationController
        
        if isPresentingInAddExerciseMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            
            var id: Int?
            if let exercise = exercise {
                id = exercise.id
            }
            let name = exerciseNameTextField.text ?? ""
            let row = bodyRegionPicker.selectedRowInComponent(0)
            let bodyRegion = bodyRegions[row]
            
            // Set the exercise to be passed to exerciseListTableViewController after the unwind segue.
            exercise = Exercise(id: id, name: name, bodyRegion: bodyRegion)
        }
    }
}
