//
//  ExerciseView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/26/23.
//

import SwiftUI

//MARK: ExerciseView
struct ExerciseView: View {
    
    @Binding var rootIsActive: Bool

    var category: String
    var exercises: [String] {
        switch category {
        case "Chest":
            return ChestExercises().exercises
        case "Shoulders":
            return ShoulderExercises().exercises
        case "Back":
            return BackExercises().exercises
        case "Biceps":
            return BicepExercises().exercises
        case "Triceps":
            return TricepExercises().exercises
        default:
            return []
        }
    }
        
    var body: some View {
        VStack {
            List(exercises, id: \.self) { exercise in
                NavigationLink(destination: SelectedExercise(rootIsActive: self.$rootIsActive, selectedExercise: exercise)){
                    Text(exercise)
                    
                        .navigationBarTitleDisplayMode(.inline)

                        .toolbar { // <2>
                            ToolbarItemGroup(placement: .principal) {
                                VStack {
                                    Text("Blank Routine")
                                        .font(.custom("Cairo-Regular", size: 40))
                                        .foregroundColor(.white)

                                }
                            }
                            
                        }
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
                }
                .isDetailLink(false)
            }
        }
    }
}

