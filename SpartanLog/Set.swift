//
//  Set.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

class Set: NSObject {
    
    // MARK: Properties
    
    var id: Int?
    var workoutID: Int?
    var exerciseID: Int?
    var repetitions: Int
    var weight: Double
    var createdAt: String?
    var updatedAt: String?
    
    // MARK: Initialization
    
    init?(id: Int? = nil, workoutID: Int? = nil, exerciseID: Int? = nil, repetitions: Int, weight: Double, createdAt: String? = nil, updatedAt: String? = nil) {
        self.id = id
        self.workoutID = workoutID
        self.exerciseID = exerciseID
        self.repetitions = repetitions
        self.weight = weight
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if repetitions <= 0 || weight < 0 {
            return nil
        }
    }
}
