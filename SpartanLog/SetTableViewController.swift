//
//  SetTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SetTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var sets = [Set]()
    var workout: Workout?
    var exercise: Exercise?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let workout = workout, let exercise = exercise {
            getSets(workout, exercise: exercise)
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
        return sets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SetTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SetTableViewCell
        
        // Fetches the appropriate set for the data source layout.
        let set = sets[indexPath.row]
        
        let row = indexPath.row + 1
        cell.setNumberLabel!.text = String(row)
        cell.repetitionsLabel!.text = String(set.repetitions)
        cell.weightLabel!.text = String(set.weight)
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSetDetail" {
            let setDetailViewController = segue.destinationViewController as! SetDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedSetCell = sender as? SetTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSetCell)!
                let selectedSet = sets[indexPath.row]
                setDetailViewController.set = selectedSet
            }
        }
    }
    
    @IBAction func unwindToSetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? SetDetailViewController, set = sourceViewController.set {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                updateSet(set, indexPath: selectedIndexPath)
                
            } else {
                createSet(set)
            }
        }
    }
    
    // MARK: Timer Functions
    
    @IBOutlet weak var timerDisplay: UIBarButtonItem!
    var timer: NSTimer?
    var timerForSeconds: NSTimer?
    var secondCounter: Int?
    
    func timerFinished() {
        timerDisplay.title = "Timer"
        
        timer?.invalidate()
        timer = nil
        
        timerForSeconds?.invalidate()
        timerForSeconds = nil
    }
    
    func displaySeconds() {
        secondCounter! -= 1
        
        if secondCounter == 0 {
            timerForSeconds?.invalidate()
            timerForSeconds = nil
        }
        
        let minutes = secondCounter! / 60
        var minutesDisplay = "\(minutes):"
        
        let seconds = secondCounter! % 60
        var secondsDisplay = "\(seconds)"
        
        if seconds < 10 {
            secondsDisplay = "0\(seconds)"
        }
        if minutes == 0 {
            minutesDisplay = ""
        }
        
        timerDisplay.title = "\(minutesDisplay)\(secondsDisplay)"
    }
    
    @IBAction func startOrStopTimer(sender: UIBarButtonItem) {
        
        if timer != nil {
            timerDisplay.title = "Timer"
            
            timer?.invalidate()
            timer = nil
            
            timerForSeconds?.invalidate()
            timerForSeconds = nil
            
            return
        }
        
        let alertController = UIAlertController(
            title: "UIAlertController",
            message: "This is UIAlertController",
            preferredStyle: .ActionSheet)
        
        let thirtySecondsTimer = UIAlertAction(
            title: "30 Sec",
            style: .Default,
            handler: { (alert) in
                
                self.secondCounter = 30
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(
                    30,
                    target: self,
                    selector: #selector(self.timerFinished),
                    userInfo: nil,
                    repeats: false)
                
                self.timerForSeconds = NSTimer.scheduledTimerWithTimeInterval(
                    1,
                    target: self,
                    selector: #selector(self.self.displaySeconds),
                    userInfo: nil,
                    repeats: true)
        })
        
        let oneMinuteTimer = UIAlertAction(
            title: "1 Min",
            style: .Default,
            handler: { (alert) in
                
                self.secondCounter = 60
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(
                    60,
                    target: self,
                    selector: #selector(self.timerFinished),
                    userInfo: nil,
                    repeats: false)
                
                self.timerForSeconds = NSTimer.scheduledTimerWithTimeInterval(
                    1,
                    target: self,
                    selector: #selector(self.self.displaySeconds),
                    userInfo: nil,
                    repeats: true)
        })
        
        let twoMinuteTimer = UIAlertAction(
            title: "2 Min",
            style: .Default,
            handler: { (alert) in
                
                self.secondCounter = 120
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(
                    120,
                    target: self,
                    selector: #selector(self.timerFinished),
                    userInfo: nil,
                    repeats: false)
                
                self.timerForSeconds = NSTimer.scheduledTimerWithTimeInterval(
                    1,
                    target: self,
                    selector: #selector(self.self.displaySeconds),
                    userInfo: nil,
                    repeats: true)
        })
        
        let cancelTimer = UIAlertAction(
            title: "Cancel",
            style: .Default,
            handler: { (alert) in })
        
        alertController.addAction(thirtySecondsTimer)
        alertController.addAction(oneMinuteTimer)
        alertController.addAction(twoMinuteTimer)
        alertController.addAction(cancelTimer)
        
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil)
    }
    
    
    // MARK:  CRUD Operations
    
    func getSets(workout: Workout, exercise: Exercise) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getSets(workout, exercise: exercise) { (sets, error) in
            
            if let sets = sets {
                performUIUpdatesOnMain {
                    self.sets = sets
                    self.tableView.reloadData()
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    func createSet(set: Set) {
        self.startActivityIndicator()
        
        set.workoutID = self.workout?.id
        set.exerciseID = self.exercise?.id
        
        SpartanAPI.sharedInstance().createSet(set) { (set, error) in
            
            if let set = set {
                performUIUpdatesOnMain {
                    let newIndexPath = NSIndexPath(forRow: self.sets.count, inSection: 0)
                    self.sets.append(set)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    func updateSet(set: Set, indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        set.workoutID = self.workout?.id
        set.exerciseID = self.exercise?.id
        
        SpartanAPI.sharedInstance().updateSet(set) { (set, error) in
            
            if let set = set {
                performUIUpdatesOnMain {
                    self.sets[indexPath.row] = set
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                }
                
            } else {
                print(error)
            }
            
            self.stopActivityIndicator()
        }
    }
    
    func deleteSet(indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        let set = sets[indexPath.row]
        
        SpartanAPI.sharedInstance().deleteSet(set) {
            (sets, error) in
            if let error = error {
                print(error)
                
            } else {
                performUIUpdatesOnMain {
                    self.sets.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
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
