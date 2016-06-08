//
//  Workout.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

class Workout: NSObject {
    
    // MARK: Properties
    
    var id: Int?
    var name: String
    var createdAt: String?
    var updatedAt: String?
    
    // the associated exercises are added when getWorkout() is called
    var exercises: [Exercise]?
    
    // MARK: Initialization
    
    init?(id: Int? = nil, name: String, createdAt: String? = nil, updatedAt: String? = nil, exercises: [Exercise]? = nil) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.exercises = exercises
        
        super.init()
        
        // Initialization should fail if there is no name.
        if name.isEmpty {
            return nil
        }
    }
}
