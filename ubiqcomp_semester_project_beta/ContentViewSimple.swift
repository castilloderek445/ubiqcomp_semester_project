//
//  ContentView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct ContentViewSimple: View {
    
    @State private var workoutLog: [WorkoutLogEntrySimple] = []

    @State private var searchText = "Filter Workouts"
    
    var body: some View {
        
        VStack {
            VStack(spacing:0) {
                BannerView(text: "Workout Log")
                TextField("Search", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(Color.gray.opacity(1))
                    .cornerRadius(10)
                    .padding()
            }
            
            VStack() {
                NavigationView {
                    List(workoutLog, id: \.workoutDate) { entry in

                        Text("\(entry.workoutDate) - \(entry.workout.map { $0.exerciseName }.joined(separator: ", "))")
                    }
                    .navigationBarItems(trailing: Button(action: addWorkoutLogEntry) {
                        Text("Add Workout")
                    })
                } // end of navigationview
                .onAppear(perform: loadWorkoutLog)
                
            }
            Spacer()
        } // end of top vstack
    } // end of body
    
    func addWorkoutLogEntry() {
        // Simulate adding a workout log entry
        //let newEntry = WorkoutLogEntry(date: Date(), exercise: "Bench Press", sets: 3, reps: 10, weight: 135.0)
        let newEntry = WorkoutLogEntrySimple(workoutDate: Date(),
                                             workout: [WorkoutLogEntrySimple.Exercise(exerciseName: "Bench Press", setNumber: 1, weight: 135.0, reps: 10)])

        workoutLog.append(newEntry)
        
        // Save the workout log to a JSON file
        saveWorkoutLog()
    }
    
    func saveWorkoutLog() {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(workoutLog)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("workoutLog.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving workout log: \(error.localizedDescription)")
        }
    }
    
    func loadWorkoutLog() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("workoutLog.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                workoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
