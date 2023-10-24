//
//  WorkoutLogModel.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import Foundation

// for ContentViewSimple
struct WorkoutLogEntrySimple: Codable{
    var workoutDate: Date
    var workout: [Exercise]

    struct Exercise: Codable {
        var exerciseName: String
        var setNumber: Int
        var weight: Double
        var reps: Int
    }
}

// for ContentView (experimental zone)
struct WorkoutLogEntry: Codable, Identifiable{
    var id = UUID()
    var workoutDate: Date
    var workout: [Exercise]

    struct Exercise: Codable {
        var exerciseName: String
        var sets: [WorkoutSet]
    }

    struct WorkoutSet: Codable {
        var setNumber: Int
        var reps: Int
        var weight: Double
        // Add other properties as needed
    }

}
