//
//  SetService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    func getSets(workout: Workout, exercise: Exercise, completionHandler: (result: [Set]?, error: NSError?) -> Void) {
        print("\ngetSets")
        
        let path = "sets"
        
        let parameters = [
            "workoutID": workout.id!,
            "exerciseID": exercise.id!
        ]
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: parameters) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var sets = [Set]()
                    
                    for result in results {
                        let id = result["id"] as? Int
                        let workoutID = result["workout_id"] as? Int
                        let exerciseID = result["exercise_id"] as? Int
                        let repetitions = result["repetitions"] as? Int
                        let weight = result["weight"] as? Int
                        let createdAt = result["created_at"] as? String
                        let updatedAt = result["updated_at"] as? String
                        
                        sets.append(Set(id: id!, workoutID: workoutID!, exerciseID: exerciseID!, repetitions: repetitions!, weight: weight!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    completionHandler(result: sets, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func getSet(set: Set, completionHandler: (result: Set?, error: NSError?) -> Void) {
        print("\ngetSet")
        
        let path = "sets/\(set.id!)"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["set"] as? [String:AnyObject] {
                    
                    var workouts = [Workout]()
                    if let results = results["workouts"] as? [String:AnyObject] {
                        let id = results["id"] as? Int
                        let name = results["name"] as? String
                        let createdAt = results["created_at"] as? String
                        let updatedAt = results["updated_at"] as? String
                        
                        workouts.append(Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    let id = results["id"] as? Int
                    let workoutID = results["workout_id"] as? Int
                    let exerciseID = results["exercise_id"] as? Int
                    let repetitions = results["repetitions"] as? Int
                    let weight = results["weight"] as? Int
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let set = Set(id: id!, workoutID: workoutID!, exerciseID: exerciseID!, repetitions: repetitions!, weight: weight!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: set, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createSet(set: Set, completionHandler: (result: Set?, error: NSError?) -> Void)  {
        print("\ncreateSet")
        
        let path = "sets"
        
        let jsonBodyDictionary = [
            "repetitions": set.repetitions,
            "weight": set.weight
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
                    let workoutID = results["workout_id"] as? Int
                    let exerciseID = results["exercise_id"] as? Int
                    let repetitions = results["repetitions"] as? Int
                    let weight = results["weight"] as? Int
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let set = Set(id: id!, workoutID: workoutID!, exerciseID: exerciseID!, repetitions: repetitions!, weight: weight!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: set, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createSet parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createSet response"]))
                }
            }
        }
    }
    
    func updateSet(set: Set, completionHandler: (result: Set?, error: NSError?) -> Void)  {
        print("\nupdateSet")
        
        let path = "sets/\(set.id!)"
        
        let jsonBodyDictionary = [
            "repetitions": set.repetitions,
            "weight": set.weight
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
                
                if let results = results["set"] as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let workoutID = results["workout_id"] as? Int
                    let exerciseID = results["exercise_id"] as? Int
                    let repetitions = results["repetitions"] as? Int
                    let weight = results["weight"] as? Int
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let set = Set(id: id!, workoutID: workoutID!, exerciseID: exerciseID!, repetitions: repetitions!, weight: weight!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: set, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createSet parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createSet response"]))
                }
            }
        }
    }
    
    func deleteSet(set: Set, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteSet")
        
        let path = "sets/\(set.id!)"
        
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