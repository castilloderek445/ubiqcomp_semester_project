//
//  ExerciseListView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

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
    var exercises = ["Pull Ups", "Barbell Row", "Deadlift", "Romanian Deadlift", "Lat Pulldown", "Barbell Row", "Seated Cable Row"]
}

struct BicepExercises: Identifiable {
    var id = UUID()
    var exercises = ["Barbell Curl", "Cable Curl", "Dumbbell Curl", "Seated Incline Dumbbell Curl", "EZ-Bar Curl"]
}

struct TricepExercises: Identifiable {
    var id = UUID()
    var exercises = ["Dumbbell Overhead Triceps Extension", "Ring Dip", "Triceps Pulldown", "Katana Pull"]
}

struct ExerciseListView: View {
    
//    let bodyParts = [
//        BodyPart(name: "Chest", exercises: ChestExercises().exercises),
//        BodyPart(name: "Shoulders", exercises: ShoulderExercises().exercises),
//        BodyPart(name: "Back", exercises: BackExercises().exercises),
//        BodyPart(name: "Biceps", exercises: BicepExercises().exercises),
//        BodyPart(name: "Triceps", exercises: TricepExercises().exercises)
//    ]
    
    let bodyParts = ["Chest", "Shoulders", "Back", "Biceps", "Triceps"]
    
    var body: some View {
        VStack() {
            VStack(spacing:0) {
                BannerView(text: "Blank Routine")
                SubBannerView(text: "Select an exercise to start")
            }
            
            VStack {
                NavigationView {
                    List(bodyParts, id: \.self) { bodyPart in
                        NavigationLink(destination: ExerciseView(category: bodyPart)) {
                            Text(bodyPart)
                        }
                    }
                }
            }
        }
    }
}

struct ExerciseView: View {
    
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
                NavigationLink(destination: SelectedExercise()){
                    Text(exercise)
                }
            }
        }
    }
}

struct SelectedExercise: View {
    var body: some View {
        VStack {
            // where they'll input their information, put in another file
            // at this step, will use the input to start building the Exercise
        }
    }
}

#Preview {
    ExerciseListView()
}
