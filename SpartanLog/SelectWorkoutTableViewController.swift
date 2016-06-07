//
//  SelectWorkoutTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SelectWorkoutTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var group: Group?
    var workouts = [Workout]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let group = group {
            getGroup(group)
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
        return workouts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SelectWorkoutTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SelectWorkoutTableViewCell
        
        // Fetches the appropriate workout for the data source layout.
        let workout = workouts[indexPath.row]
        
        cell.nameLabel!.text = workout.name
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSelectExerciseList" {
            let selectExerciseTableViewController = segue.destinationViewController as! SelectExerciseTableViewController
            
            // Get the cell that generated this segue.
            if let selectedWorkoutCell = sender as? SelectWorkoutTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedWorkoutCell)!
                let selectedWorkout = workouts[indexPath.row]
                selectExerciseTableViewController.workout = selectedWorkout
            }
        }
    }
    
    // MARK:  CRUD Operations
    
    func getGroup(group: Group) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getGroup(group) { (group, error) in
            
            performUIUpdatesOnMain {
                if let group = group {
                    self.group = group
                    self.workouts = group.workouts!
                    self.tableView.reloadData()
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
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
