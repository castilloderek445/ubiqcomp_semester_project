//
//  ChosenRoutineReviewView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/31/23.
//

import SwiftUI

struct ChosenRoutineReviewView: View {
    
    @Binding var rootIsActive2: Bool
    @State var routine: Routine
    @Binding var routineList: [RoutineList]
    @State var routineEntry: [Routine] = []
    @State private var overallWorkoutLog: [WorkoutLogEntrySimple] = []
    
    @State private var cancelAlert = false
    @State private var finishAlert = false
    @State private var routineName: String = "My Routine" //default name for textfield
    

    
    var body: some View {
        VStack(spacing: 0) {
            BannerView(text:"Review Workout")
            HStack(spacing:1) {
                
                //MARK: CANCEL BUTTON
                Button(action: {
                    cancelAlert = true
                }) {
                    Text("Cancel Workout")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Are you sure you want to cancel this Workout?", isPresented: $cancelAlert) {
                    Button("Delete Workout", role: .destructive) {
                        self.rootIsActive2 = false
                    }
                    Button("Continue Workout", role: .cancel) {}
                }
                
                //MARK: FINISH BUTTON
                Button(action: {
                    finishAlert = true
                }) {
                    Text("Finish Workout")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Enter a name for your Routine", isPresented: $finishAlert) {
                    
                    TextField("", text: $routineName)
                    Button("Finish Workout") {
                        addRoutineEntry()
                        self.rootIsActive2 = false
                        
                    }
                    
                    Button("Continue Workout", role: .cancel) {}
                }
                
            } // end of top buttons HStack
            .background(.gray)
            
            DateBannerView()
            
            List {
                ForEach(Array(routine.workouts.enumerated()), id: \.element.id) { index, entry in

                    let exerciseNames = entry.workout.map {
                        $0.exerciseName }.joined(separator: ", ")
                    
                    let weight = entry.workout.map { String($0.weight) }
                    
                    let reps = entry.workout.map {String($0.reps) }
                    
                    let formattedText = "\(exerciseNames)\nWeight: \(weight.joined(separator: ", ")) lbs\nReps: \(reps.joined(separator: ", ")) reps"
                    
                    NavigationLink(destination: EditChosenRoutineView(entry: self.$routine.workouts[index])) {
                        Text("\(formattedText)")
                    }

                }
            } // end of list
            
        } // end of top VStack
    } // end of body
    
    func addRoutineEntry() {
        loadRoutines()
        routine.routineName = self.routineName
        routineEntry.append(routine)
        saveRoutine()
        //updateRoutineList()
        print("boop")
    }
    
    func loadRoutines() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routines.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                routineEntry = try decoder.decode([Routine].self, from: workoutLogData)
            } catch {
                print("Error loading routines file: \(error.localizedDescription)")
            }
        }
    }
    
    func saveRoutine() {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(routineEntry)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("routines.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving to routine file: \(error.localizedDescription)")
        }   
    }
} // end of struct

#Preview {
    MainView()
}
