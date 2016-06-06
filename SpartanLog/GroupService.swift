//
//  GroupService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    func getGroups(completionHandler: (result: [Group]?, error: NSError?) -> Void) {
        print("\ngetGroups")
        
        let path = "groups"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var groups = [Group]()
                    
                    for result in results {
                        let id = result["id"] as? Int
                        let name = result["name"] as? String
                        let createdAt = result["created_at"] as? String
                        let updatedAt = result["updated_at"] as? String
                        
                        groups.append(Group(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    completionHandler(result: groups, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func getGroup(group: Group, completionHandler: (result: Group?, error: NSError?) -> Void) {
        print("\ngetGroup")
        
        let path = "groups/\(group.id!)"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["group"] as? [String:AnyObject] {
                    
                    var workouts = [Workout]()
                    if let results = results["workouts"] as? [String:AnyObject] {
                        let id = results["id"] as? Int
                        let name = results["name"] as? String
                        let createdAt = results["created_at"] as? String
                        let updatedAt = results["updated_at"] as? String
                        
                        workouts.append(Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let group = Group(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!, workouts: workouts)
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createGroup(group: Group, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\ncreateGroup")
        
        let path = "groups"
        
        let jsonBodyDictionary = [
            "name": group.name
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        /* 2. Make the request */
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody!, withToken: true) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let group = Group(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createGroup parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createGroup response"]))
                }
            }
        }
    }
    
    func updateGroup(group: Group, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\nupdateGroup")
        
        let path = "groups/\(group.id!)"
        
        let jsonBodyDictionary = [
            "name": group.name
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        /* 2. Make the request */
        taskForPUTMethod(path, parameters: nil, jsonBody: jsonBody!) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["group"] as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let group = Group(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createGroup parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createGroup response"]))
                }
            }
        }
    }
    
    func deleteGroup(group: Group, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteGroup")
        
        let path = "groups/\(group.id!)"
        
        taskForDELETEMethod(path) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: results, error: nil)
            }
        }
    }
}