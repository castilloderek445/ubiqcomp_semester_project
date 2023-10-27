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
    
    var body: some View {
        VStack(spacing: 0) {
            BannerView(text:"Review Workout")
            HStack(spacing:1) {
                Button(action: {
                    // cancel entire thingy,
                    // dialog: Are you sure you want to cancel exercise? Y/N
                    // Y: send to add exercise screen
                    // OR make this the Add Set button
                }) {
                    Text("Cancel")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))
                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                
                Button(action: {
                    // change to navlink or whatever to send to review page
                    // append tempWorkoutLog to tempOverallWorkoutLog
                    // call func to clear tempWorkoutLog
                }) {
                    Text("Finish")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
                
            } // end of top buttons HStack
            .background(.gray)
            
            DateBannerView()
            
            List(overallWorkoutLog, id: \.id) { entry in
                
                let weightFormatted = entry.workout.map { $0.weight }.reduce(0, +)
                
                Text("\(entry.workout.map { $0.exerciseName }.map{String($0)}.joined(separator: " ")), \(String(format: "%.1f", weightFormatted)) lbs, \(entry.workout.map { $0.reps }.reduce(0, +)) reps")
            
            }
            .onAppear(perform: loadWorkoutLog)
            
            Button(action: { self.rootIsActive = false}) {
                Text("Pop to root")
            }
            
            NavigationLink("", destination: ExerciseListView(rootIsActive: $rootIsActive), isActive: $goToList )
                Button("fuck you") {
                    goToList = true
                }
            
            
            
            
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
}



#Preview {
    MainView()
}
