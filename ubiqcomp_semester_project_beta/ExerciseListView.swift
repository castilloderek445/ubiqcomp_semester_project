//
//  ExerciseListView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

//MARK: struct stuff

struct BodyPart: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [String]
}

struct ChestExercises: Identifiable {
    var id = UUID()
    var exercises = ["Flat Barbell Bench Press","Incline Barbell Bench Press","Decline Barbell Bench Press","Flat Dumbbell Bench Press","Incline Dumbbell Bench Press","Decline Dumbbell Bench Press","Cable Crossover","Seated Machine Fly"]
}

struct ShoulderExercises: Identifiable {
    var id = UUID()
    var exercises = ["Overhead Press","Cable Raise","Side Dumbbell Lateral Raise","Cable External Rotation","Front Lateral Raise","Dumbbell Overhead Press", "Face Pull", "Reverse Dumbbell Fly", "Reverse Cable Fly"]
}

struct BackExercises: Identifiable {
    var id = UUID()
    var exercises = ["Pull Ups", "Deadlift", "Romanian Deadlift", "Lat Pulldown", "Barbell Row", "Seated Cable Row"]
}

struct BicepExercises: Identifiable {
    var id = UUID()
    var exercises = ["Barbell Curl", "Cable Curl", "Dumbbell Curl", "Seated Incline Dumbbell Curl", "EZ-Bar Curl"]
}

struct TricepExercises: Identifiable {
    var id = UUID()
    var exercises = ["Dumbbell Overhead Triceps Extension", "Ring Dip", "Triceps Pulldown", "Katana Pull"]
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 5, style: .continuous)
                .stroke(Color.gray, lineWidth: 1)
        ).padding(0)
    }
}

//MARK: ExerciseListView
struct ExerciseListView: View {
        
    @Binding var rootIsActive: Bool
    @Binding var newRoutineIsActive: Bool
    @State var exerciseListIsActive: Bool = false
    
    @State private var isActiveArray: [Bool] = Array(repeating: false, count: 5) // One state variable per row
    
    let bodyParts = ["Chest", "Shoulders", "Back", "Biceps", "Triceps"]
    
    var body: some View {
        
        List(0..<bodyParts.count, id: \.self) { bodyPart in
            
            NavigationLink(destination: ExerciseView(rootIsActive: self.$rootIsActive, newRoutineIsActive: self.$newRoutineIsActive, category: bodyParts[bodyPart])) {
                Text(bodyParts[bodyPart])
            }
            
            .isDetailLink(false)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Blank Routine")
                            .font(.custom("Cairo-Regular", size: 40))
                            .foregroundColor(.white)
                            //.padding(.top, -20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}





#Preview {
    MainView()
}
