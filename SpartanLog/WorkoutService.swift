//
//  WorkoutService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    func getWorkouts(completionHandler: (result: [Workout]?, error: NSError?) -> Void) {
        print("\ngetWorkouts")
        
        let path = "workouts"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var workouts = [Workout]()
                    
                    for result in results {
                        let id = result["id"] as? Int
                        let name = result["name"] as? String
                        let createdAt = result["created_at"] as? String
                        let updatedAt = result["updated_at"] as? String
                        
                        workouts.append(Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    completionHandler(result: workouts, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func getWorkout(workout: Workout, completionHandler: (result: Workout?, error: NSError?) -> Void) {
        print("\ngetWorkout")
        
        let path = "workouts/\(workout.id!)"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["workout"] as? [String:AnyObject] {
                    
                    var exercises = [Exercise]()
                    if let results = results["exercises"] as? [[String:AnyObject]] {
                        
                        for result in results {
                            let id = result["id"] as? Int
                            let name = result["name"] as? String
                            let bodyRegion = result["bodyRegion"] as? String
                            let createdAt = result["created_at"] as? String
                            let updatedAt = result["updated_at"] as? String
                            
                            exercises.append(Exercise(id: id!, name: name!, bodyRegion: bodyRegion!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                        }
                    }
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let workout = Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!, exercises: exercises)
                    
                    completionHandler(result: workout, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createWorkout(workout: Workout, completionHandler: (result: Workout?, error: NSError?) -> Void)  {
        print("\ncreateWorkout")
        
        let path = "workouts"
        
        let jsonBodyDictionary = [
            "name": workout.name
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
                    
                    let workout = Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: workout, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createWorkout parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createWorkout response"]))
                }
            }
        }
    }
    
    func updateWorkout(workout: Workout, completionHandler: (result: Workout?, error: NSError?) -> Void)  {
        print("\nupdateWorkout")
        
        let path = "workouts/\(workout.id!)"
        
        let jsonBodyDictionary = [
            "name": workout.name
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
                
                if let results = results["workout"] as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let workout = Workout(id: id!, name: name!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: workout, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createWorkout parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createWorkout response"]))
                }
            }
        }
    }
    
    func deleteWorkout(workout: Workout, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteWorkout")
        
        let path = "workouts/\(workout.id!)"
        
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