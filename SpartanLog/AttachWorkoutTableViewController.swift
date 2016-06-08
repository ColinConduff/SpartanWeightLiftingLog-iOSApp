//
//  AttachWorkoutTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class AttachWorkoutTableViewController: UITableViewController {
        
    // MARK: Properties
    
    var group: Group?
    var workouts = [Workout]()
    var workoutsToAttach = [Workout]()
    var workoutsToDetach = [Workout]()
    var checkedWorkouts = [Workout:Bool]()
    var originallyChecked = [Workout:Bool]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let group = group {
            getGroup(group)
        }
        getWorkouts()
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
        return workouts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "AttachWorkoutTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AttachWorkoutTableViewCell
        
        let workout = workouts[indexPath.row]
        cell.nameLabel!.text = workout.name
        
        if checkedWorkouts[workout] == true {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
        
            let workout = workouts[indexPath.row]
            
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checkedWorkouts[workout] = false
                
                workoutsToDetach.append(workout)
                if let index = workoutsToAttach.indexOf(workout) {
                    workoutsToAttach.removeAtIndex(index)
                }
                
            } else {
                cell.accessoryType = .Checkmark
                checkedWorkouts[workout] = true
                
                workoutsToAttach.append(workout)
                if let index = workoutsToDetach.indexOf(workout) {
                    workoutsToDetach.removeAtIndex(index)
                }
            }
        }
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitAttachAndDetachWorkouts(sender: UIBarButtonItem) {
        attachWorkouts()
        detachWorkouts()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:  CRUD Operations
    
    func getWorkouts() {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getWorkouts() { (workouts, error) in
            
            if let workouts = workouts {
                performUIUpdatesOnMain {
                    self.workouts = workouts
                    
                    if self.group?.workouts != nil {
                        self.buildCheckedWorkoutsDictionary()
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    func getGroup(group: Group) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getGroup(group) { (group, error) in
            
            if let group = group {
                performUIUpdatesOnMain {
                    
                    self.group = group
                    
                    if !self.workouts.isEmpty {
                        self.buildCheckedWorkoutsDictionary()
                        self.tableView.reloadData()
                    }
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    func attachWorkouts() {
        for workout in workoutsToAttach {
            if !originallyChecked[workout]! {
                SpartanAPI.sharedInstance().attachWorkout(group!, workout: workout) {_,_ in}
            }
        }
    }
    
    func detachWorkouts() {
        for workout in workoutsToDetach {
            if originallyChecked[workout]! {
                SpartanAPI.sharedInstance().detachWorkout(group!, workout: workout) {_,_ in}
            }
        }
    }
    
    // MARK: Helper Functions
    
    func buildCheckedWorkoutsDictionary() {
        if let groupWorkouts = group?.workouts {
            for workout in workouts {
                var found = false
                for groupWorkout in groupWorkouts {
                    if workout.name == groupWorkout.name {
                        checkedWorkouts[workout] = true
                        originallyChecked[workout] = true
                        found = true
                    }
                }
                if !found {
                    checkedWorkouts[workout] = false
                    originallyChecked[workout] = false
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
