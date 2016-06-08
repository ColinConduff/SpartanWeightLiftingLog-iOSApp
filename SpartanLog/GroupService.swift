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
        
        let path = Const.Group.Path
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var groups = [Group]()
                    
                    for result in results {
                        let group = self.useResponseDataToMakeGroup(result)
                        
                        if let group = group {
                            groups.append(group)
                        }
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
        
        let path = Const.Group.PathWithID(group.id!)
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["group"] as? [String:AnyObject] {
                    
                    var workouts = [Workout]()
                    if let results = results["workouts"] as? [[String:AnyObject]] {
                        
                        for result in results {
                            let workout = self.useResponseDataToMakeWorkout(result)
                            
                            if let workout = workout {
                                workouts.append(workout)
                            }
                        }
                    }
                    
                    let group = self.useResponseDataToMakeGroup(results)
                    
                    if group == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making group", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making group"]))
                    }
                    
                    group!.workouts = workouts
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createGroup(group: Group, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\ncreateGroup")
        
        let path = Const.Group.Path
        
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
                    
                    let group = self.useResponseDataToMakeGroup(results)
                    
                    if group == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making group", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making group"]))
                    }
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createGroup parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createGroup response"]))
                }
            }
        }
    }
    
    func updateGroup(group: Group, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\nupdateGroup")
        
        let path = Const.Group.PathWithID(group.id!)
        
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
                    
                    let group = self.useResponseDataToMakeGroup(results)
                    
                    if group == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making group", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making group"]))
                    }
                    
                    completionHandler(result: group, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createGroup parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createGroup response"]))
                }
            }
        }
    }
    
    func deleteGroup(group: Group, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteGroup")
        
        let path = Const.Group.PathWithID(group.id!)
        
        taskForDELETEMethod(path) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: results, error: nil)
            }
        }
    }
    
    func attachWorkout(group: Group, workout: Workout, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\nattachWorkout")
        
        let path = Const.Group.PathWithIDAndAttach(group.id!)
        
        let jsonBodyDictionary = [
            "workoutID": workout.id!
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
                completionHandler(result: nil, error: nil)
                    
            }
        }
    }
    
    func detachWorkout(group: Group, workout: Workout, completionHandler: (result: Group?, error: NSError?) -> Void)  {
        print("\ndetachWorkout")
        
        let path = Const.Group.PathWithIDAndDetach(group.id!)
        
        let jsonBodyDictionary = [
            "workoutID": workout.id!
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
                completionHandler(result: nil, error: nil)
                
            }
        }
    }
    
    // MARK: Helper Functions
    
    func useResponseDataToMakeGroup(result: AnyObject) -> Group? {
        
        let id = result[Const.Group.Key.id] as? Int
        let name = result[Const.Group.Key.name] as? String
        let createdAt = result[Const.Group.Key.created_at] as? String
        let updatedAt = result[Const.Group.Key.updated_at] as? String
        
        if let id = id, let name = name,
            let createdAt = createdAt, let updatedAt = updatedAt {
            return Group(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt)
        } else {
            return nil
        }
    }
}