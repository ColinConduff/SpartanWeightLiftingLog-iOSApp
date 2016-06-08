//
//  WorkoutTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class WorkoutTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var workouts = [Workout]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        let cellIdentifier = Const.Storyboard.WorkoutTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! WorkoutTableViewCell
        
        // Fetches the appropriate workout for the data source layout.
        let workout = workouts[indexPath.row]
        
        cell.nameLabel!.text = workout.name
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            deleteWorkout(indexPath)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Const.Storyboard.ShowWorkoutDetail {
            let workoutDetailViewController = segue.destinationViewController as! WorkoutDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? WorkoutTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                workoutDetailViewController.workout = selectedWorkout
            }
        }
    }
    
    @IBAction func unwindToWorkoutList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? WorkoutDetailViewController, workout = sourceViewController.workout {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                updateWorkout(workout, indexPath: selectedIndexPath)
                
            } else {
                createWorkout(workout)
            }
        }
    }
    
    // MARK:  CRUD Operations
    
    func getWorkouts() {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getWorkouts() { (workouts, error) in
            
            performUIUpdatesOnMain {
                if let workouts = workouts {
                    self.workouts = workouts
                    self.tableView.reloadData()
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func createWorkout(workout: Workout) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().createWorkout(workout) { (workout, error) in
            
            performUIUpdatesOnMain {
                if let workout = workout {
                    let newIndexPath = NSIndexPath(forRow: self.workouts.count, inSection: 0)
                    self.workouts.append(workout)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func updateWorkout(workout: Workout, indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().updateWorkout(workout) { (workout, error) in
            
            performUIUpdatesOnMain {
                if let workout = workout {
                    self.workouts[indexPath.row] = workout
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func deleteWorkout(indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        let workout = workouts[indexPath.row]
        
        SpartanAPI.sharedInstance().deleteWorkout(workout) {
            (workouts, error) in
            
            performUIUpdatesOnMain {
                if let error = error {
                    print(error)
                    
                } else {
                    self.workouts.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    // MARK: Helper Functions
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
