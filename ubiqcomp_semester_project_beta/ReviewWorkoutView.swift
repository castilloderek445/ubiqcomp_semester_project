//
//  ReviewWorkoutView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/24/23.
//

import SwiftUI

struct ReviewWorkoutView: View {

    @Binding var rootIsActive: Bool
    
    @State var goToList: Bool = false
        
    @State private var overallWorkoutLog: [WorkoutLogEntrySimple] = []
    @State private var cancelAlert = false
    @State private var finishAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            BannerView(text:"Review Workout")
            HStack(spacing:1) {
                Button(action: {
                    cancelAlert = true
                }) {
                    Text("Cancel")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Are you sure you want to cancel this Workout?", isPresented: $cancelAlert) {
                    Button("Delete Workout", role: .destructive) {
                        // clear mergedWorkoutLog.json
                        // clear overallWorkoutLog as well?
                        // pop to root
                        clearJSON()
                        self.rootIsActive = false
                    }
                    Button("Continue Workout", role: .cancel) {}
                }
                
                Button(action: {
                    finishAlert = true
                }) {
                    Text("Finish")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Are you sure you want to Finish this Workout?", isPresented: $finishAlert) {
                    Button("Finish Workout") {
                        // check if state var isBlankRoutine = true (from pressing it in AddWorkoutView
                        // if true, ask if want to save new workout Routine
                            // following actions...
                        // if false (already using Routine), do regular save - pop are you sure you wanna save
                            // append overallworkoutlog to real workout mergeFiles()
                            // clear overallworkoutlog clearJSON (same way as cleared tempworkoutlog)
                            // pop to root or to workout history
                        
                    }
                    Button("Continue Workout", role: .cancel) {}
                }
                
            } // end of top buttons HStack
            .background(.gray)
            
            DateBannerView()

            List{
                
                ForEach($overallWorkoutLog, id: \.id) {entry in
                    let exerciseNames = entry.workout.map {
                        $0.exerciseName.wrappedValue }.joined(separator: ", ")
                    
                    let weight = entry.workout.map { String($0.weight.wrappedValue) }
                    let reps = entry.workout.map { String($0.reps.wrappedValue) }
                    
                    let formattedText = "\(exerciseNames)\nWeight: \(weight.joined(separator: ", ")) lbs\nReps: \(reps.joined(separator: ", ")) reps"
                    
                    NavigationLink(destination: EditExerciseView(entry: entry)) {
                        Text(formattedText)
                    }
                }.onDelete { indexSet in
                    overallWorkoutLog.remove(atOffsets: indexSet)
                    //saveWorkoutLog() can probably save this save for the Finish Workout button
                }

            
            }
            .onAppear(perform: loadWorkoutLog)
            
            //MARK: testing stuff

            Button(action: { self.rootIsActive = false}) {
                Text("Pop to root")
            }
            
            NavigationLink("", destination: ExerciseListView(rootIsActive: $rootIsActive), isActive: $goToList )
                Button("fuck you") {
                    goToList = true
                }
                .navigationBarBackButtonHidden(true)
            
        }
        Spacer()
    } // end of Body
    
    func loadWorkoutLog() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("mergedWorkoutLog.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                overallWorkoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
            }
        }
    }
    
    func clearJSON() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("mergedWorkoutLog.json")
            do {
                overallWorkoutLog.removeAll()
                
                let blankData = try JSONEncoder().encode(overallWorkoutLog)
                try blankData.write(to: fileURL, options: .atomic)
                print("cleared mergedWorkoutLog.json")
                
            } catch {
                print("Error deleting workout log: \(error.localizedDescription)")
            }
        }
    }
    
    func saveWorkoutLog() {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(overallWorkoutLog)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("mergedWorkoutLog.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving workout log: \(error.localizedDescription)")
        }
    }
    
    //func saveWorkout: append to realworkoutlog
    //func saveWorkoutRoutine:
        // method A: save a whole new json file containing this routine
            // pros/cons: easy to implement, might bloat storage
        // method B: append to a json file that contains routines as individual enetries
            // pros/cons: harder to access
}



#Preview {
    MainView()
}
