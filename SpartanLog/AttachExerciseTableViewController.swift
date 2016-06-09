//
//  AttachExerciseTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class AttachExerciseTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var workout: Workout?
    var exercises = [Exercise]()
    var exercisesToAttach = [Exercise]()
    var exercisesToDetach = [Exercise]()
    var checkedExercises = [Exercise:Bool]()
    var originallyChecked = [Exercise:Bool]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let workout = workout {
            getWorkout(workout)
        }
        getExercises()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = Const.Storyboard.AttachExerciseTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AttachExerciseTableViewCell
        
        let exercise = exercises[indexPath.row]
        cell.nameLabel!.text = exercise.name
        
        if checkedExercises[exercise] == true {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            let exercise = exercises[indexPath.row]
            
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checkedExercises[exercise] = false
                
                exercisesToDetach.append(exercise)
                if let index = exercisesToAttach.indexOf(exercise) {
                    exercisesToAttach.removeAtIndex(index)
                }
                
            } else {
                cell.accessoryType = .Checkmark
                checkedExercises[exercise] = true
                
                exercisesToAttach.append(exercise)
                if let index = exercisesToDetach.indexOf(exercise) {
                    exercisesToDetach.removeAtIndex(index)
                }
            }
        }
    }
    
    // MARK: Navigation
    
    @IBAction func submitAttachAndDetachExercises(sender: UIBarButtonItem) {
        attachExercises()
        detachExercises()
    }
    
    // MARK:  CRUD Operations
    
    func getExercises() {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getExercises() { (exercises, error) in
            
            performUIUpdatesOnMain {
                
                if let exercises = exercises {
                    self.exercises = exercises
                    
                    if self.workout?.exercises != nil {
                        self.buildCheckedExercisesDictionary()
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func getWorkout(workout: Workout) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getWorkout(workout) { (workout, error) in
            
            performUIUpdatesOnMain {
                if let workout = workout {
                        
                    self.workout = workout
                    
                    if !self.exercises.isEmpty {
                        self.buildCheckedExercisesDictionary()
                        self.tableView.reloadData()
                    }
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func attachExercises() {
        for exercise in exercisesToAttach {
            if !originallyChecked[exercise]! {
                SpartanAPI.sharedInstance().attachExercise(workout!, exercise: exercise) {_,_ in}
            }
        }
    }
    
    func detachExercises() {
        //self.startActivityIndicator()
        
        for exercise in exercisesToDetach {
            if originallyChecked[exercise]! {
                SpartanAPI.sharedInstance().detachExercise(workout!, exercise: exercise) {_,_ in}
            }
        }
    }
    
    // MARK: Helper Functions
    
    func buildCheckedExercisesDictionary() {
        if let workoutExercises = workout?.exercises {
            for exercise in exercises {
                var found = false
                for workoutExercise in workoutExercises {
                    if exercise.name == workoutExercise.name {
                        checkedExercises[exercise] = true
                        originallyChecked[exercise] = true
                        found = true
                    }
                }
                if !found {
                    checkedExercises[exercise] = false
                    originallyChecked[exercise] = false
                }
            }
        }
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
