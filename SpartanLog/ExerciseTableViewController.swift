//
//  ExerciseTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var exercises = [Exercise]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        
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
        let cellIdentifier = "ExerciseTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ExerciseTableViewCell
        
        // Fetches the appropriate exercise for the data source layout.
        let exercise = exercises[indexPath.row]
        
        cell.nameLabel!.text = exercise.name
        cell.bodyRegionLabel.text = exercise.bodyRegion
        
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
            deleteExercise(indexPath)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowExerciseDetail" {
            let exerciseDetailViewController = segue.destinationViewController as! ExerciseDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedExerciseCell = sender as? ExerciseTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedExerciseCell)!
                let selectedExercise = exercises[indexPath.row]
                exerciseDetailViewController.exercise = selectedExercise
            }
        }
    }
    
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? ExerciseDetailViewController, exercise = sourceViewController.exercise {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                updateExercise(exercise, indexPath: selectedIndexPath)
            
            } else {
                createExercise(exercise)
            }
        }
    }
    
    // MARK:  CRUD Operations
    
    func getExercises() {
        SpartanAPI.sharedInstance().getExercises() { (exercises, error) in
            
            if let exercises = exercises {
                performUIUpdatesOnMain {
                    self.exercises = exercises
                    self.tableView.reloadData()
                }
            
            } else {
                print(error)
            }
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    func createExercise(exercise: Exercise) {
        SpartanAPI.sharedInstance().createExercise(exercise) { (exercise, error) in
            
            if let exercise = exercise {
                performUIUpdatesOnMain {
                    let newIndexPath = NSIndexPath(forRow: self.exercises.count, inSection: 0)
                    self.exercises.append(exercise)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
                
            } else {
                print(error)
            }
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    func updateExercise(exercise: Exercise, indexPath: NSIndexPath) {
        SpartanAPI.sharedInstance().updateExercise(exercise) { (exercise, error) in
            
            if let exercise = exercise {
                performUIUpdatesOnMain {
                    self.exercises[indexPath.row] = exercise
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
                
            } else {
                print(error)
            }
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
    
    func deleteExercise(indexPath: NSIndexPath) {
        let exercise = exercises[indexPath.row]
        
        SpartanAPI.sharedInstance().deleteExercise(exercise) {
            (exercises, error) in
            if let error = error {
                print(error)
            
            } else {
                performUIUpdatesOnMain {
                    self.exercises.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
            }
            
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
        }
    }
}
