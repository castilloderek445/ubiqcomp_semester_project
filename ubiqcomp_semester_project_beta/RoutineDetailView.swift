//
//  RoutineDetailView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 11/1/23.
//

import SwiftUI

struct RoutineDetailView: View {
    
    @Binding var routine: Routine
    var saveRoutine: (Routine) -> Void
    @State private var finishAlert = false
    
    
    var body: some View {
        VStack(spacing: 0) {
            BannerView(text:"Review Workout")
            HStack(spacing:1) {
                                
                //MARK: FINISH BUTTON
                Button(action: {
                    finishAlert = true
                }) {
                    Text("Save Changes")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                .alert("Confirm changes to exercise(s)?", isPresented: $finishAlert) {
                    
                    Button("Confirm") {
                        saveRoutine(routine)
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                
            } // end of top buttons HStack
            .background(.gray)
            List {
                ForEach(Array(routine.workouts.enumerated()), id: \.element.id) { index, entry in
                    
                    let exerciseNames = entry.workout.map {
                        $0.exerciseName }.joined(separator: ", ")
                    
                    let weight = entry.workout.map { String($0.weight) }
                    
                    let reps = entry.workout.map {String($0.reps) }
                    
                    let formattedText = "\(exerciseNames)\nWeight: \(weight.joined(separator: ", ")) lbs\nReps: \(reps.joined(separator: ", ")) reps"
                    
                    NavigationLink(destination: EditRoutineDetailView(entry: self.$routine.workouts[index])) {
                        Text("\(formattedText)")
                    }
                    
                }.onDelete { indexSet in
                    routine.workouts.remove(atOffsets: indexSet)
                    saveRoutine(routine)
                    print("deleted exercise from routinedetailview type beat")
                }
            }
        }
    }
}

#Preview {
    MainView()
}
