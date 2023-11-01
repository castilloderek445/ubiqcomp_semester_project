//
//  ContentView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct ContentViewSimple: View {
    
    @State private var routines: [Routine] = []
    
    @State private var searchText = ""

    
    var groupedRoutines: [(Date, [Routine])] {
        let grouped = Dictionary(grouping: routines) { (routine) in
            Calendar.current.startOfDay(for: routine.workouts.first?.workoutDate ?? Date())
        }
        return grouped.sorted { $0.key > $1.key }
    }
    
    // saveRoutine function in a closure to pass to subsequent views
    private var saveRoutine: (Routine) -> Void {
        return { routine in
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("routines.json")
                do {
                    var routines = self.routines // Copy the current routines
                    if let index = routines.firstIndex(where: { $0.id == routine.id }) {
                        routines[index] = routine // Replace the routine with the updated one
                        let encoder = JSONEncoder()
                        let data = try encoder.encode(routines)
                        try data.write(to: fileURL)
                        self.routines = routines // Update the @State property
                    }
                } catch {
                    print("Error saving workout log: \(error.localizedDescription)")
                }
            }
        }
    }

    var body: some View {
        
            
        // MARK: NAVIGATIONVIEW
        NavigationView {
            ZStack {
                Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1))
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                
                    HStack {
                        TextField("Filter Workouts", text: $searchText)
                            .padding()
                            .background(Color.white.opacity(0.4))
                            .foregroundColor(Color.white.opacity(0.3))
                            .cornerRadius(10)
                            .frame(maxHeight: 60) // Set the maximum height
                            .padding(10) // Adjust vertical padding to center the TextField
                    } // end of HStack

                    

                    List {
                        ForEach(groupedRoutines, id: \.0) { date, routines in
                            Section(header: Text(dateFormatted(date: date))) {
                                ForEach(routines.indices, id: \.self) { index in
                                    let routine = routines[index]
                                    NavigationLink(destination: RoutineDetailView(routine: $routines[index], saveRoutine: self.saveRoutine)) {
                                        Text(routine.routineName)
                                    }
                                }
                            }
                        }.onDelete { indexSet in 
                            routines.remove(atOffsets: indexSet)
                            updateWorkoutLog()
                            print("deleted exercise from workoutlog type beat")
                        }
                    }

                    //.listStyle(InsetGroupedListStyle())
                    //.listStyle(PlainListStyle())
                    .listStyle(GroupedListStyle())
                } // end of VStack
            } // end of ZStack

            
            // MARK: navbar stuff
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Workout Log")
                            .font(.custom("Cairo-Regular", size: 40))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
            .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        } // end of NavigationView
        .onAppear {
            loadWorkoutLog()
        }
    } // end of Body


    func dateFormatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy" // ex: Monday, January, 1, 2023
        return dateFormatter.string(from: date)
    }

    func loadWorkoutLog() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routines.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                routines = try decoder.decode([Routine].self, from: workoutLogData)
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
            }
        }
    }
    
    func updateWorkoutLog() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routines.json")
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(routines)
                try data.write(to: fileURL)
            } catch {
                print("Error saving workout log: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MainView()
}

//struct ContentViewSimple: View {
//    
//    @State private var routines: [Routine] = []
//    
//    var body: some View {
//        NavigationView {
//            List(routines, id: \.routineName) { routine in
//                NavigationLink(destination: RoutineDetailView()) {
//                    Text(routine.routineName)
//                }
//            }
//            .listStyle(InsetGroupedListStyle())
//        }
//        .onAppear {
//            loadWorkoutLog()
//        }
//    }
//    
//    func loadWorkoutLog() {
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = documentDirectory.appendingPathComponent("routines.json")
//            do {
//                let workoutLogData = try Data(contentsOf: fileURL)
//                let decoder = JSONDecoder()
//                routines = try decoder.decode([Routine].self, from: workoutLogData)
//            } catch {
//                print("Error loading workout log: \(error.localizedDescription)")
//            }
//        }
//    }
//}






// other struct

//struct ContentViewSimple: View {
//    
//    @State private var workoutLog: [WorkoutLogEntrySimple] = []
//
//    @State private var searchText = "Filter Workouts"
//    
//    var body: some View {
//        
//        VStack {
//            VStack(spacing:0) {
//                BannerView(text: "Workout Log")
//                TextField("Search", text: $searchText)
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .foregroundColor(Color.gray.opacity(1))
//                    .cornerRadius(10)
//                    .padding()
//            }
//            
//            VStack() {
//                NavigationView {
//                    List(workoutLog, id: \.workoutDate) { entry in
//
//                        Text("\(entry.workoutDate) - \(entry.workout.map { $0.exerciseName }.joined(separator: ", "))")
//                    }
//                    .navigationBarItems(trailing: Button(action: addWorkoutLogEntry) {
//                        Text("Add Workout")
//                    })
//                } // end of navigationview
//                .onAppear(perform: loadWorkoutLog)
//                
//            }
//            Spacer()
//        } // end of top vstack
//    } // end of body
//    
//    func addWorkoutLogEntry() {
//        // Simulate adding a workout log entry
//        //let newEntry = WorkoutLogEntry(date: Date(), exercise: "Bench Press", sets: 3, reps: 10, weight: 135.0)
//        let newEntry = WorkoutLogEntrySimple(workoutDate: Date(),
//                                             workout: [WorkoutLogEntrySimple.Exercise(exerciseName: "Bench Press", setNumber: 1, weight: 135.0, reps: 10)])
//
//        workoutLog.append(newEntry)
//        
//        // Save the workout log to a JSON file
//        saveWorkoutLog()
//    }
//    
//    func saveWorkoutLog() {
//        do {
//            let encoder = JSONEncoder()
//            let workoutLogData = try encoder.encode(workoutLog)
//            
//            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//                let fileURL = documentDirectory.appendingPathComponent("workoutLog.json")
//                try workoutLogData.write(to: fileURL)
//            }
//        } catch {
//            print("Error saving workout log: \(error.localizedDescription)")
//        }
//    }
//    
//    func loadWorkoutLog() {
//        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = documentDirectory.appendingPathComponent("workoutLog.json")
//            do {
//                let workoutLogData = try Data(contentsOf: fileURL)
//                let decoder = JSONDecoder()
//                workoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
//            } catch {
//                print("Error loading workout log: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//}
