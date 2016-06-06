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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
            // Delete the row from the data source
            exercises.removeAtIndex(indexPath.row)
            //saveExercises()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
                // Update an existing exercise.
                exercises[selectedIndexPath.row] = exercise
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            
            } else {
                // Add a new exercise.
                let newIndexPath = NSIndexPath(forRow: exercises.count, inSection: 0)
                exercises.append(exercise)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            // Save the exercises.
            //saveExercises()
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
        }
    }
}
