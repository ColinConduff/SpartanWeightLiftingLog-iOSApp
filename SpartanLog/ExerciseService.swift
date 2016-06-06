//
//  ExerciseService.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

extension SpartanAPI {
    func getExercises(completionHandler: (result: [Exercise]?, error: NSError?) -> Void) {
        print("\ngetExercises")
        
        let path = "exercises"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var exercises = [Exercise]()
                    
                    for result in results {
                        let id = result["id"] as? Int
                        let name = result["name"] as? String
                        let bodyRegion = result["bodyRegion"] as? String
                        let createdAt = result["created_at"] as? String
                        let updatedAt = result["updated_at"] as? String
                        
                        exercises.append(Exercise(id: id!, name: name!, bodyRegion: bodyRegion!, createdAt: createdAt!, updatedAt: updatedAt!)!)
                    }
                    
                    completionHandler(result: exercises, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func getExercise(exercise: Exercise, completionHandler: (result: Exercise?, error: NSError?) -> Void) {
        print("\ngetExercise")
        
        let path = "exercises/\(exercise.id)"
        
        /* 2. Make the request */
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["exercise"] as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let bodyRegion = results["bodyRegion"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let exercise = Exercise(id: id!, name: name!, bodyRegion: bodyRegion!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]))
                }
            }
        }
    }
    
    func createExercise(exercise: Exercise, completionHandler: (result: Exercise?, error: NSError?) -> Void)  {
        print("\ncreateExercise")
        
        let path = "exercises"
        
        let jsonBodyDictionary = [
            "name": exercise.name,
            "bodyRegion": exercise.bodyRegion
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
                    let bodyRegion = results["bodyRegion"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let exercise = Exercise(id: id!, name: name!, bodyRegion: bodyRegion!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createExercise parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createExercise response"]))
                }
            }
        }
    }
    
    func updateExercise(exercise: Exercise, completionHandler: (result: Exercise?, error: NSError?) -> Void)  {
        print("\nupdateExercise")
        
        let path = "exercises/\(exercise.id)"
        
        let jsonBodyDictionary = [
            "name": exercise.name,
            "bodyRegion": exercise.bodyRegion
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
                
                if let results = results["exercise"] as? [String:AnyObject] {
                    
                    let id = results["id"] as? Int
                    let name = results["name"] as? String
                    let bodyRegion = results["bodyRegion"] as? String
                    let createdAt = results["created_at"] as? String
                    let updatedAt = results["updated_at"] as? String
                    
                    let exercise = Exercise(id: id!, name: name!, bodyRegion: bodyRegion!, createdAt: createdAt!, updatedAt: updatedAt!)
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createExercise parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createExercise response"]))
                }
            }
        }
    }
    
    func deleteExercise(exercise: Exercise, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteExercise")
        
        let path = "exercises/\(exercise.id)"
        
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