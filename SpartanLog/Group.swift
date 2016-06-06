//
//  Group.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

class Group: NSObject {
    
    // MARK: Properties
    
    var id: Int?
    var name: String
    var createdAt: String?
    var updatedAt: String?
    var workouts: [Workout]?
    
    // MARK: Initialization
    
    init?(id: Int?, name: String, createdAt: String?, updatedAt: String?, workouts: [Workout]?) {
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.workouts = workouts
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
    }
}
