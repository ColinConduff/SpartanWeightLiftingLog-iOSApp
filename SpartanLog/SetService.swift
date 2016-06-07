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
                        let set = self.useResponseDataToMakeSet(result)
                        
                        if set != nil {
                            sets.append(set!)
                        
                        } else {
                            print("nil in getSets")
                            completionHandler(result: nil, error: NSError(domain: "Nil found when making set", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making set"]))
                        }
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
                    if let results = results["workouts"] as? [[String:AnyObject]] {
                        for result in results {
                            let workout = self.useResponseDataToMakeWorkout(result)
                            
                            if let workout = workout {
                                workouts.append(workout)
                                
                            } else {
                                print("nil in getSet")
                                completionHandler(result: nil, error: NSError(domain: "Nil found when making workout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making workout"]))
                            }
                        }
                    }
                    
                    let set = self.useResponseDataToMakeSet(results)
                    
                    if set == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making set", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making set"]))
                    }
                    
                    completionHandler(result: set, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createSet(set: Set, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ncreateSet")
        
        let path = "sets"
        
        let jsonBodyDictionary = [
            "workout_id": set.workoutID!,
            "exercise_id": set.exerciseID!,
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
                completionHandler(result: results, error: nil)
            }
        }
    }
    
    func updateSet(set: Set, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\nupdateSet")
        
        let path = "sets/\(set.id!)"
        
        let jsonBodyDictionary = [
            "workout_id": set.workoutID!,
            "exercise_id": set.exerciseID!,
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
                completionHandler(result: results, error: nil)
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
    
    // MARK: Helper Functions
    
    func useResponseDataToMakeSet(result: AnyObject) -> Set? {
        
        let id = result["id"] as? Int
        let workoutID = result["workout_id"] as? Int
        let exerciseID = result["exercise_id"] as? Int
        let repetitions = result["repetitions"] as? Int
        let weight = (result["weight"] as? NSString)?.doubleValue
        let createdAt = result["created_at"] as? String
        let updatedAt = result["updated_at"] as? String
        
        if let id = id, let workoutID = workoutID, let exerciseID = exerciseID,
            let repetitions = repetitions, let weight = weight,
            let createdAt = createdAt, let updatedAt = updatedAt {
        
            return Set(id: id, workoutID: workoutID, exerciseID: exerciseID, repetitions: repetitions, weight: weight, createdAt: createdAt, updatedAt: updatedAt)!
            
        } else {
            return nil
        }
    }
}