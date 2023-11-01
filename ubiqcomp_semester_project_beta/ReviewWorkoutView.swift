//
//  ReviewWorkoutView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/24/23.
//

import SwiftUI

struct ReviewWorkoutView: View {

    @Binding var rootIsActive: Bool
    @Binding var newRoutineIsActive: Bool
    
    @State var goToList: Bool = false
    @State var saveToRoutineList = false
        
    @State private var overallWorkoutLog: [WorkoutLogEntrySimple] = []
    @State private var routine: [Routine] = []
    @State private var routineList: [RoutineList] = []
    @State private var cancelAlert = false
    @State private var finishAlert = false
    @State private var finishAlert2 = false
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
                        // clear mergedWorkoutLog.json
                        // clear overallWorkoutLog as well?
                        // pop to root
                        clearJSON()
                        self.rootIsActive = false
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
                        // check if state var isBlankRoutine = true (from pressing it in AddWorkoutView
                        // if true, ask if want to save new workout Routine
                            // following actions...
                        // if false (already using Routine), do regular save - pop are you sure you wanna save
                            // append overallworkoutlog to real workout mergeFiles()
                            // clear overallworkoutlog clearJSON (same way as cleared tempworkoutlog)
                            // pop to root or to workout history
                        //addRoutineEntry() // saves to Routine object instance and then writes to routines.json
                        //TODO: save routine template if necessary
                        if newRoutineIsActive {
                            finishAlert2.toggle()
                        }
                        
                    }
                    
                    Button("Continue Workout", role: .cancel) {}
                }
                .alert("Would you like to also this Routine as a template for future use?", isPresented: $finishAlert2) {
                    VStack {
                        Button("Yes") {
                            self.saveToRoutineList = true
                            loadRoutineList()
                            addRoutineEntry()
                            clearJSON()
                            self.saveToRoutineList = false
                            self.rootIsActive = false
                        }
                        Button("No") {
                            addRoutineEntry()
                            clearJSON()
                            self.rootIsActive = false
                        }
                    }

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

//            Button(action: { self.rootIsActive = false}) {
//                Text("Pop to root")
//            }
            
            VStack {
                NavigationLink("", destination: ExerciseListView(rootIsActive: $rootIsActive, newRoutineIsActive: self.$newRoutineIsActive), isActive: $goToList )
                    Button("Add Exercise") {
                        goToList = true
                    }
                    .frame(width: 240, height: 90)
                    .font(.custom("Cairo-Regular", size: 28))
                    .background(Color(UIColor(red: 254/255, green: 125/255, blue: 14/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .navigationBarBackButtonHidden(true)
            } // end of navlink vstack
            .padding(.bottom, 20)
        }
        .background(Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)))
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
    
    func loadRoutines() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routines.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                routine = try decoder.decode([Routine].self, from: workoutLogData)
            } catch {
                print("Error loading routines file: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: addRoutineEntry
    
    func addRoutineEntry() {
        
        loadRoutines()
        let newRoutineEntry = Routine(routineName: routineName, workouts: overallWorkoutLog)

        routine.append(newRoutineEntry)
        
        // Save the workout log to a JSON file
        saveRoutine(log: routine)
        
        if saveToRoutineList {
            
            let newRoutineListEntry = RoutineList(routines: newRoutineEntry)
            routineList.append(newRoutineListEntry)
            saveRoutineList(entry: routineList)
        }
    }
    
    func saveRoutine(log: [Routine]) {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(log)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("routines.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving to routine file: \(error.localizedDescription)")
        }
    }
    
    func loadRoutineList() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routineList.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                routineList = try decoder.decode([RoutineList].self, from: workoutLogData)
            } catch {
                print("Error loading routines list file: \(error.localizedDescription)")
            }
        }
    }
    
    func saveRoutineList(entry: [RoutineList]) {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(entry)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("routineList.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving to routine list file: \(error.localizedDescription)")
        }
    }

}



#Preview {
    MainView()
}
