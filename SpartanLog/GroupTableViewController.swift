//
//  GroupTableViewController.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var groups = [Group]()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getGroups()
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
        return groups.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GroupTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GroupTableViewCell
        
        // Fetches the appropriate group for the data source layout.
        let group = groups[indexPath.row]
        
        cell.nameLabel!.text = group.name
        
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
            deleteGroup(indexPath)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowGroupDetail" {
            let groupDetailViewController = segue.destinationViewController as! GroupDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedGroupCell = sender as? GroupTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedGroupCell)!
                let selectedGroup = groups[indexPath.row]
                groupDetailViewController.group = selectedGroup
            }
        }
    }
    
    @IBAction func unwindToGroupList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? GroupDetailViewController, group = sourceViewController.group {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                updateGroup(group, indexPath: selectedIndexPath)
                
            } else {
                createGroup(group)
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
    
    func createGroup(group: Group) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().createGroup(group) { (group, error) in
            
            performUIUpdatesOnMain {
                if let group = group {
                    let newIndexPath = NSIndexPath(forRow: self.groups.count, inSection: 0)
                    self.groups.append(group)
                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func updateGroup(group: Group, indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        SpartanAPI.sharedInstance().updateGroup(group) { (group, error) in
            
            performUIUpdatesOnMain {
                if let group = group {
                    self.groups[indexPath.row] = group
                    self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                    
                } else {
                    print(error)
                }
                
                self.stopActivityIndicator()
            }
        }
    }
    
    func deleteGroup(indexPath: NSIndexPath) {
        self.startActivityIndicator()
        
        let group = groups[indexPath.row]
        
        SpartanAPI.sharedInstance().deleteGroup(group) { (groups, error) in
            
            performUIUpdatesOnMain {
                if let error = error {
                    print(error)
                    
                } else {
                    self.groups.removeAtIndex(indexPath.row)
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
