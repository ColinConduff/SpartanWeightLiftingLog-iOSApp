//
//  Exercise.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/6/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

import Foundation

class Exercise: NSObject {
    
    // MARK: Properties
    
    var id: Int?
    var name: String
    var bodyRegion: String
    var createdAt: String?
    var updatedAt: String?
    
    // MARK: Initialization
    
    init?(id: Int? = nil, name: String, bodyRegion: String, createdAt: String? = nil, updatedAt: String? = nil) {
        self.id = id
        self.name = name
        self.bodyRegion = bodyRegion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || bodyRegion.isEmpty {
            return nil
        }
    }
}
