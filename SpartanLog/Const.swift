//
//  Constants.swift
//  SpartanLog
//
//  Created by Colin Conduff on 6/8/16.
//  Copyright © 2016 Colin Conduff. All rights reserved.
//

struct Const {
    struct Storyboard {
        
        static let AfterLoginTabBarController = "AfterLoginTabBarController"
        
        static let ExerciseTableViewCell = "ExerciseTableViewCell"
        static let ShowExerciseDetail = "ShowExerciseDetail"
        
        static let WorkoutTableViewCell = "WorkoutTableViewCell"
        static let ShowWorkoutDetail = "ShowWorkoutDetail"
        
        static let ShowAttachExerciseTable = "ShowAttachExerciseTable"
        static let AttachExerciseTableViewCell = "AttachExerciseTableViewCell"
        
        static let GroupTableViewCell = "GroupTableViewCell"
        static let ShowGroupDetail = "ShowGroupDetail"
        
        static let ShowAttachWorkoutTable = "ShowAttachWorkoutTable"
        static let AttachWorkoutTableViewCell = "AttachWorkoutTableViewCell"
        
        static let SetTableViewCell = "SetTableViewCell"
        static let ShowSetDetail = "ShowSetDetail"
        
        static let ShowSetList = "ShowSetList"
        
        static let SelectExerciseTableViewCell = "SelectExerciseTableViewCell"
        static let ShowSelectExerciseList = "ShowSelectExerciseList"
        
        static let SelectWorkoutTableViewCell = "SelectWorkoutTableViewCell"
        static let ShowSelectWorkoutList = "ShowSelectWorkoutList"
        
        static let SelectGroupTableViewCell = "SelectGroupTableViewCell"
        static let ShowSelectGroupList = "ShowSelectGroupList"
    }
    
    struct Set {
        static let Path = "sets"
        static func PathWithID(id: Int) -> String {
            return "sets/\(id)"
        }
        static let DataFromPaginatedResults = "data"
        static let SetContainer = "set"
        
        struct Key {
            static let id = "id"
            static let workout_id = "workout_id"
            static let exercise_id = "exercise_id"
            static let repetitions = "repetitions"
            static let weight = "weight"
            static let created_at = "created_at"
            static let updated_at = "updated_at"
        }
    }
    
    struct Group {
        static let Path = "groups"
        static func PathWithID(id: Int) -> String {
            return "groups/\(id)"
        }
        static func PathWithIDAndAttach(id: Int) -> String {
            return "groups/\(id)/attach"
        }
        static func PathWithIDAndDetach(id: Int) -> String {
            return "groups/\(id)/detach"
        }
        static let DataFromPaginatedResults = "data"
        static let GroupContainer = "group"
        
        struct Key {
            static let id = "id"
            static let name = "name"
            static let created_at = "created_at"
            static let updated_at = "updated_at"
        }
    }
    
    struct Workout {
        static let Path = "workouts"
        static func PathWithID(id: Int) -> String {
            return "workouts/\(id)"
        }
        static func PathWithIDAndAttach(id: Int) -> String {
            return "workouts/\(id)/attach"
        }
        static func PathWithIDAndDetach(id: Int) -> String {
            return "workouts/\(id)/detach"
        }
        static let DataFromPaginatedResults = "data"
        static let WorkoutContainer = "workout"
        
        struct Key {
            static let id = "id"
            static let name = "name"
            static let created_at = "created_at"
            static let updated_at = "updated_at"
        }
    }
    
    struct Exercise {
        static let Path = "exercises"
        static func PathWithID(id: Int) -> String {
            return "exercises/\(id)"
        }
        static let DataFromPaginatedResults = "data"
        static let ExerciseContainer = "exercise"
        
        struct Key {
            static let id = "id"
            static let name = "name"
            static let bodyRegion = "bodyRegion"
            static let created_at = "created_at"
            static let updated_at = "updated_at"
        }
    }
}