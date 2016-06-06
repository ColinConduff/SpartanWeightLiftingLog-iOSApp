//
//  SelectExerciseTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SelectExerciseTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var workout: Workout?
    var exercises = [Exercise]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let workout = workout {
            getWorkout(workout)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cellIdentifier = "SelectExerciseTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SelectExerciseTableViewCell
        
        // Fetches the appropriate exercise for the data source layout.
        let exercise = exercises[indexPath.row]
        
        cell.nameLabel!.text = exercise.name
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSetList" {
            let setTableViewController = segue.destinationViewController as! SetTableViewController
            
            // Get the cell that generated this segue.
            if let selectedExerciseCell = sender as? SelectExerciseTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedExerciseCell)!
                let selectedExercise = exercises[indexPath.row]
                setTableViewController.exercise = selectedExercise
                setTableViewController.workout = workout
            }
        }
    }
    
    // MARK:  CRUD Operations
    
    func getWorkout(workout: Workout) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getWorkout(workout) { (workout, error) in
            
            if let workout = workout {
                performUIUpdatesOnMain {
                    self.workout = workout
                    self.exercises = workout.exercises!
                    self.tableView.reloadData()
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    // MARK: Helper Functions
    
    func startActivityIndicator() {
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
    }
}
