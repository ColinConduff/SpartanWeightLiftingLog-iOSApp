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
        
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var workouts = [Workout]()
                    
                    for result in results {
                        let workout = self.useResponseDataToMakeWorkout(result)
                        
                        if let workout = workout {
                            workouts.append(workout)
                        }
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
        
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["workout"] as? [String:AnyObject] {
                    
                    var exercises = [Exercise]()
                    if let results = results["exercises"] as? [[String:AnyObject]] {
                        
                        for result in results {
                            let exercise = self.useResponseDataToMakeExercise(result)
                            
                            if let exercise = exercise {
                                exercises.append(exercise)
                            }
                        }
                    }
                    
                    let workout = self.useResponseDataToMakeWorkout(results)
                    
                    if workout == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making workout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making workout"]))
                    }
                    
                    workout!.exercises = exercises
                    
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
        
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody!, withToken: true) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results as? [String:AnyObject] {
                    
                    let workout = self.useResponseDataToMakeWorkout(results)
                    
                    if workout == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making workout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making workout"]))
                    }
                    
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
        
        taskForPUTMethod(path, parameters: nil, jsonBody: jsonBody!) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                if let results = results["workout"] as? [String:AnyObject] {
                    
                    let workout = self.useResponseDataToMakeWorkout(results)
                    
                    if workout == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making workout", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making workout"]))
                    }
                    
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
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: results, error: nil)
            }
        }
    }
    
    func attachExercise(workout: Workout, exercise: Exercise, completionHandler: (result: Workout?, error: NSError?) -> Void)  {
        print("\nattachExercise")
        
        let path = "workouts/\(workout.id!)/attach"
        
        let jsonBodyDictionary = [
            "exerciseID": exercise.id!
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody!, withToken: true) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: nil, error: nil)
                
            }
        }
    }
    
    func detachExercise(workout: Workout, exercise: Exercise, completionHandler: (result: Workout?, error: NSError?) -> Void)  {
        print("\ndetachExercise")
        
        let path = "workouts/\(workout.id!)/detach"
        
        let jsonBodyDictionary = [
            "exerciseID": exercise.id!
        ]
        
        var jsonBody: NSData?
        do {
            jsonBody = try NSJSONSerialization.dataWithJSONObject(jsonBodyDictionary, options: NSJSONWritingOptions.PrettyPrinted)
        } catch let error as NSError {
            print(error)
        }
        
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody!, withToken: true) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: nil, error: nil)
                
            }
        }
    }
    
    // MARK: Helper Functions
    
    func useResponseDataToMakeWorkout(result: AnyObject) -> Workout? {
        
        let id = result["id"] as? Int
        let name = result["name"] as? String
        let createdAt = result["created_at"] as? String
        let updatedAt = result["updated_at"] as? String
        
        if let id = id, let name = name,
            let createdAt = createdAt, let updatedAt = updatedAt {
            return Workout(id: id, name: name, createdAt: createdAt, updatedAt: updatedAt)
        } else {
            return nil
        }
    }
}