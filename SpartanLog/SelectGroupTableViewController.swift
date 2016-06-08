//
//  SelectGroupTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class SelectGroupTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var groups = [Group]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getGroups()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SelectGroupTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SelectGroupTableViewCell
        
        // Fetches the appropriate group for the data source layout.
        let group = groups[indexPath.row]
        
        cell.nameLabel!.text = group.name
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSelectWorkoutList" {
            let selectWorkoutTableViewController = segue.destinationViewController as! SelectWorkoutTableViewController
            
            // Get the cell that generated this segue.
            if let selectedGroupCell = sender as? SelectGroupTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedGroupCell)!
                let selectedGroup = groups[indexPath.row]
                selectWorkoutTableViewController.group = selectedGroup
            }
        }
    }
    
    // MARK:  CRUD Operations
    
    func getGroups() {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().getGroups() { (groups, error) in
            
            performUIUpdatesOnMain {
                if let groups = groups {
                    self.groups = groups
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
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
