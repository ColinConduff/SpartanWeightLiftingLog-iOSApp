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
    var exercises: [Exercise]?
    
    // MARK: Initialization
    
    init?(id: Int?, name: String, createdAt: String?, updatedAt: String?, exercises: [Exercise]?) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.exercises = exercises
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
}
