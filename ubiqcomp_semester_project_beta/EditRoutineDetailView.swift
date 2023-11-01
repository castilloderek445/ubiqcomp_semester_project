//
//  EditRoutineDetailView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 11/1/23.
//

import SwiftUI

struct EditRoutineDetailView: View {
    
    @Binding var entry: WorkoutLogEntrySimple
    
    @State private var newWeight: Double = 0.0
    @State private var newReps: Int = 0
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
                        if let idx = entry.workout.firstIndex(where: { $0.exerciseName == entry.workout.first?.exerciseName }) {
                            entry.workout[idx].weight = newWeight
                            entry.workout[idx].reps = newReps
                        }
                        
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
            } // end of top buttons HStack
            .background(.gray)
            
            //MARK: Input Section
            VStack {
                VStack(spacing: 20) {
                    
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
                                self.newWeight -= 0.5
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
                            TextField("Enter weight", value: $newWeight, formatter: decimalFormatter)
                                .frame(width: 150)
                                .textFieldStyle(CustomTextFieldStyle())
                                .font(.system(size: 32))
                                .background(Color.white)
                                .multilineTextAlignment(.center)
                            Button(action: {
                                self.newWeight += 0.5
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
                                self.newReps -= 1
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
                            TextField("Enter reps", value: $newReps, formatter: NumberFormatter())
                                .frame(width: 150)
                                .textFieldStyle(CustomTextFieldStyle())
                                .font(.system(size: 32))
                                .background(Color.white)
                                .multilineTextAlignment(.center)
                            Button(action: {
                                self.newReps += 1
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
                    } // end of reps VStack
                    
                } // end of input VStack
                .padding(10)
                .background(Color.gray.opacity(0.2))
                
                Spacer()
                
                
            } // end of top VStack
        }
    }

}

#Preview {
    MainView()
}
