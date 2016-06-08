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
        
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                
                if let results = results["data"] as? [[String:AnyObject]] {
                    
                    var exercises = [Exercise]()
                    
                    for result in results {
                        let exercise = self.useResponseDataToMakeExercise(result)
                        
                        if let exercise = exercise {
                            exercises.append(exercise)
                        } else {
                            completionHandler(result: nil, error: NSError(domain: "Nil found when making exercise", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making exercise"]))
                        }
                    }
                    
                    completionHandler(result: exercises, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getExercises parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getExercises"]))
                }
            }
        }
    }
    
    func getExercise(exercise: Exercise, completionHandler: (result: Exercise?, error: NSError?) -> Void) {
        print("\ngetExercise")
        
        let path = "exercises/\(exercise.id!)"
        
        taskForGETMethod(path, parameters: nil) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["exercise"] as? [String:AnyObject] {
                    
                    let exercise = self.useResponseDataToMakeExercise(results)
                    
                    if exercise == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making exercise", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making exercise"]))
                    }
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "getExercise parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getExercise"]))
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
        
        taskForPOSTMethod(path, parameters: nil, jsonBody: jsonBody!, withToken: true) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results as? [String:AnyObject] {
                    
                    let exercise = self.useResponseDataToMakeExercise(results)
                    
                    if exercise == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making exercise", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making exercise"]))
                    }
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createExercise parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createExercise response"]))
                }
            }
        }
    }
    
    func updateExercise(exercise: Exercise, completionHandler: (result: Exercise?, error: NSError?) -> Void)  {
        print("\nupdateExercise")
        
        let path = "exercises/\(exercise.id!)"
        
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
        
        taskForPUTMethod(path, parameters: nil, jsonBody: jsonBody!) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
            } else {
                
                if let results = results["exercise"] as? [String:AnyObject] {
                    
                    let exercise = self.useResponseDataToMakeExercise(results)
                    
                    if exercise == nil {
                        completionHandler(result: nil, error: NSError(domain: "Nil found when making exercise", code: 0, userInfo: [NSLocalizedDescriptionKey: "Nil found when making exercise"]))
                    }
                    
                    completionHandler(result: exercise, error: nil)
                    
                } else {
                    completionHandler(result: nil, error: NSError(domain: "createExercise parse error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse createExercise response"]))
                }
            }
        }
    }
    
    func deleteExercise(exercise: Exercise, completionHandler: (result: AnyObject?, error: NSError?) -> Void)  {
        print("\ndeleteExercise")
        
        let path = "exercises/\(exercise.id!)"
        
        taskForDELETEMethod(path) { (results, error) in
            
            if let error = error {
                completionHandler(result: nil, error: error)
                
            } else {
                completionHandler(result: results, error: nil)
            }
        }
    }
    
    // MARK: Helper Functions
    
    func useResponseDataToMakeExercise(result: AnyObject) -> Exercise? {
        
        let id = result["id"] as? Int
        let name = result["name"] as? String
        let bodyRegion = result["bodyRegion"] as? String
        let createdAt = result["created_at"] as? String
        let updatedAt = result["updated_at"] as? String
        
        if let id = id, let name = name, let bodyRegion = bodyRegion,
            let createdAt = createdAt, let updatedAt = updatedAt {
            return Exercise(id: id, name: name, bodyRegion: bodyRegion, createdAt: createdAt, updatedAt: updatedAt)
        } else {
            return nil
        }
    }
}