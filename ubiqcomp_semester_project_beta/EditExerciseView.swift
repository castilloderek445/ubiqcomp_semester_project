//
//  EditExerciseView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/29/23.
//

import SwiftUI

struct EditExerciseView: View {
    
    @Binding var entry: WorkoutLogEntrySimple
    @State private var overallWorkoutLog: [WorkoutLogEntrySimple] = []
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    @State private var finishAlert = false
    
    let decimalFormatter: NumberFormatter = {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = 2
        decimalFormatter.minimumFractionDigits = 1
        decimalFormatter.allowsFloats = true
        return decimalFormatter
    }()
    
    var body: some View {
        VStack(spacing: 0) {
            BannerView(text:"Edit Exercise")
            HStack(spacing: 1) {
                Button(action: {
                    finishAlert = true
                }) {
                    Text("Finish Edit")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Confirm Modifications", isPresented: $finishAlert) {
                    Button("Confirm") {
                        updateFile()
                        
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
            } // end of top buttons HStack
            .background(.gray)
            
            
            //MARK: Input Section
            VStack {
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
                } // end of Input VStack
                .padding(10)
                .background(Color.gray.opacity(0.2))
                
                Spacer()
            } // end of top VStack
            //.padding()
        }
    }
    
    func updateFile() {
        editEntry(weight: weight, reps: reps)
        
        loadWorkoutLog()
        
        
        if let idx = overallWorkoutLog.firstIndex(where: { $0.id == entry.id }) {
            overallWorkoutLog[idx] = entry
            
            print("entry ID: \(entry.id)")
            if let weight = overallWorkoutLog[idx].workout.first?.weight {
                print("Weight at index \(idx): \(weight)")
            }
        }
        
        
        saveWorkoutLog()
    }
    
    func editEntry(weight: Double, reps: Int) {

        if let firstExercise = entry.workout.first {
            
            entry.workout[0].weight = weight
            entry.workout[0].reps = reps
            
            print("input weight and reps: \(weight), \(reps)")
            print("enetry new weight and reps: \(entry.workout[0].weight), \(entry.workout[0].reps)")

        }
    }
    
    func loadWorkoutLog() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("mergedWorkoutLog.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                overallWorkoutLog = try decoder.decode([WorkoutLogEntrySimple].self, from: workoutLogData)
                print("loaded mergedworkoutlog in EditExerciseView")
            } catch {
                print("Error loading workout log: \(error.localizedDescription)")
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
    
}
