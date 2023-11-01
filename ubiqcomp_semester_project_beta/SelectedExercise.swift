//
//  SelectedExercise.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/26/23.
//

import SwiftUI

//MARK: SelectedExerciseView
struct SelectedExercise: View {
    
    @Binding var rootIsActive: Bool
    @Binding var newRoutineIsActive: Bool

        
    var selectedExercise: String
    @State private var toReview = false
    
    @State private var workoutLog: [WorkoutLogEntrySimple] = []
    @State private var overallLog: [WorkoutLogEntrySimple] = [] // to test merging files
    
    //@Binding var hideBanners: Bool
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    @State private var setNumber: Int = 0
    
    let decimalFormatter: NumberFormatter = {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = 2
        decimalFormatter.minimumFractionDigits = 1
        decimalFormatter.allowsFloats = true
        return decimalFormatter
    }()
    
    // placeholder for building workoutlog model
    var items = [""]
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            //MARK: NavigationLink stuff
            NavigationLink(destination: ReviewWorkoutView(rootIsActive: self.$rootIsActive, newRoutineIsActive: self.$newRoutineIsActive), isActive: $toReview){
                
                //EmptyView()
                HStack(spacing:1) {
                    
                    //MARK: Cancel Button
                    Button(action: {
                        // cancel entire thingy,
                        // dialog: Are you sure you want to cancel exercise? Y/N
                        // set ExerciseListView's isActive var to false, set AddWorkoutView's isActive to true? i see another problem lol
                        // pop to root AddWorkoutView
                        clearJSON()
                        self.toReview = false
                        self.rootIsActive = false
                    }) {
                        Text("Cancel")
                            .font(.custom("Cairo-Regular", size: 20))
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))
                            .foregroundColor(.white)
                            .cornerRadius(0)
                    }
                    
                    //MARK: Done Button
                    Button(action: {
                        mergeFiles() //append current exercise to list of all exercises added in current workout
                        clearJSON() // clear this current exercise's list, so to be used in next exercise
                        self.toReview = true // move to ReviewWorkoutReview
                        
                    }) {
                        Text("Done")
                            .font(.custom("Cairo-Regular", size: 20))
                            .frame(maxWidth: .infinity, maxHeight: 20)
                            .padding()
                            .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                            .cornerRadius(0)
                    }
                    
                } // end of top buttons HStack
                .background(.gray)
            }
            .isDetailLink(false)
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItemGroup(placement: .principal) {
                    VStack {
                        Text("\(selectedExercise)")
                            .font(.custom("Cairo-Regular", size: 50))
                            .foregroundColor(.white)
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
            //end of navigation link properties
        } // end of NavigationLink
        
        //MARK: Input Section
        VStack {
            
            // Weight Section
            VStack(spacing: 20) { // spacing between Weight and Reps sections
                
                // Weight Section
                VStack(spacing: 0) {
                    HStack {
                        Text("Weight (lbs)")
                            .font(.custom("Cairo-Regular", size: 24))
                            .padding(.leading, 30)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.weight -= 0.5
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                                Image(systemName: "minus")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        TextField("Enter weight", value: $weight, formatter: decimalFormatter)
                            .frame(width: 150)
                            .textFieldStyle(CustomTextFieldStyle())
                            .font(.system(size: 32))
                            .background(Color.white)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            self.weight += 0.5
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                                Image(systemName: "plus")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                } // end of Weight VStack

                
                // Reps Section
                VStack(spacing: 0) {
                    HStack {
                        Text("Reps")
                            .font(.custom("Cairo-Regular", size: 24))
                            .padding(.leading, 30)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            self.reps -= 1
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                                Image(systemName: "minus")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        TextField("Enter reps", value: $reps, formatter: NumberFormatter())
                            .frame(width: 150)
                            .textFieldStyle(CustomTextFieldStyle())
                            .font(.system(size: 32))
                            .background(Color.white)
                            .multilineTextAlignment(.center)
                        Button(action: {
                            self.reps += 1
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(10)
                                    .foregroundColor(.gray)
                                Image(systemName: "plus")
                                    .font(.system(size: 25))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                } // end of Reps VStack
                
                VStack(spacing: 0) {
                    //MARK: ADD SET Button
                    Button("Add Set") {
                        
                        setNumber += 1
                        addWorkoutLogEntry(exName: selectedExercise, setNumber: setNumber, weight: weight, reps: reps)
                    }
                    .frame(width: 100, height: 53)
                    .font(.custom("Cairo-Regular", size: 22))
                    .background(Color(UIColor(red: 254/255, green: 125/255, blue: 14/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
            } // end of Input VStack
            .padding(10)
            .background(Color.gray.opacity(0.2))
            
            
            //MARK: test Buttons
            // buttons used for testing, keep commented out
//            Button("Clear JSON") {
//                clearJSON()
//            }
//            Button("merge files") {
//                mergeFiles()
//            }
//            
            
            //MARK: Display WORKOUT SETS
            List {
                ForEach(workoutLog, id: \.workoutDate)  { entry in
                    let weightFormatted = entry.workout.map { $0.weight }.reduce(0, +)
                    
                    Text("\(entry.workout.map { $0.exerciseName }.map{String($0)}.joined(separator: " ")), \(String(format: "%.1f", weightFormatted)) lbs, \(entry.workout.map { $0.reps }.reduce(0, +)) reps")
                }
                .onDelete { indexSet in
                    workoutLog.remove(atOffsets: indexSet)
                    saveWorkoutLog(log: workoutLog)
                    print("deleted an exercise type beat")
                }
            }
            .cornerRadius(0)
            .background(Color.gray.opacity(0.2))
            .scrollContentBackground(.hidden)
            .onAppear{
                loadTempWorkoutLog(log: workoutLog, fileName: "tempWorkoutLog.json")
                loadOverallWorkoutLog(log: overallLog, fileName: "mergedWorkoutLog.json")
            }
            
            Spacer()
            
        } // end of highest VStack
        .padding()
    } // end of Body
    
    //MARK: addWorkoutLogEntry Function
    func addWorkoutLogEntry(exName: String, setNumber: Int, weight: Double, reps: Int) {
                
        let newEntry = WorkoutLogEntrySimple(workoutDate: Date(),
                                             workout: [WorkoutLogEntrySimple.Exercise(exerciseName: exName, setNumber: setNumber, weight: weight, reps: reps)])

        workoutLog.append(newEntry)
        
        // Save the workout log to a JSON file
        saveWorkoutLog(log: workoutLog)
    }
    
    //MARK: saveWorkoutLog Function
    func saveWorkoutLog(log: [WorkoutLogEntrySimple]) {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(log)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("tempWorkoutLog.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving workout log: \(error.localizedDescription)")
        }
    }
    
    //MARK: loadWorkoutLog Function
    func loadTempWorkoutLog(log: [WorkoutLogEntrySimple], fileName: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                workoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
            }
        }
    }
    
    func loadOverallWorkoutLog(log: [WorkoutLogEntrySimple], fileName: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                overallLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: clearJSON Function
    // proof of concept of clearing and merging workoutLog objects
    // append workoutLog array to some new array
    // save new array to another JSON file, "overallWorkoutLog.json
    // this file will display in the review screen
    // whenever user adds more workouts, repeat this process
    // when implementing this between the two views, load overallWorkoutLog.json here and make array object of it
    // when moving to review screen, load it and make object again
    func clearJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("tempWorkoutLog.json")
            do {
//                let workoutLogData = try Data(contentsOf: fileURL)
//                let decoder = JSONDecoder()
//                workoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
                workoutLog.removeAll()
                
                let blankData = try JSONEncoder().encode(workoutLog)
                try blankData.write(to: fileURL, options: .atomic)
                print("cleared tempWorkoutLog.json")
                
            } catch {
                print("Error deleting workout log: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: mergeFiles Function
    func mergeFiles() {
        
        // append
        overallLog += workoutLog
        
        // save to json file
        do {
            
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(overallLog)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("mergedWorkoutLog.json")
                try workoutLogData.write(to: fileURL)
                print("appended workoutLog to overallLog")
            }
        } catch {
            print("Error saving workout log: \(error.localizedDescription)")
        }
    }
    
    //MARK: formatDate Function
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
} // end of Struct

#Preview {
    MainView()
}
