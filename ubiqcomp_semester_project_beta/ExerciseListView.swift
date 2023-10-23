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
//    @State private var hideBanners = true
    
    var body: some View {
//        VStack() {
//            
//            VStack(spacing:0) {
//                BannerView(text: "Blank Routine")
//                SubBannerView(text: "Select an exercise to start")
//            }
//            
//            VStack {
//                NavigationView {
//                    List(bodyParts, id: \.self) { bodyPart in
//                        NavigationLink(destination: ExerciseView(category: bodyPart)) {
//                            Text(bodyPart)
//                        }
//                    }
//                }
//            }
//        }
        
        NavigationView {
            List(bodyParts, id: \.self) { bodyPart in
                NavigationLink(destination: ExerciseView(category: bodyPart)) {
                    Text(bodyPart)
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
    
    //@Binding var hideBanners: Bool
    
    var body: some View {
        VStack {
            List(exercises, id: \.self) { exercise in
                NavigationLink(destination: SelectedExercise()){
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
            }
        }
    }
}

struct SelectedExercise: View {
    
    //@Binding var hideBanners: Bool
    @State private var weight: Double = 0.0
    @State private var reps: Int = 0
    
    let decimalFormatter: NumberFormatter = {
        let decimalFormatter = NumberFormatter()
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = 2
        decimalFormatter.minimumFractionDigits = 2
        decimalFormatter.allowsFloats = true
        return decimalFormatter
    }()
    
    // placeholder for building workoutlog model
    var items = [""]
    
    var body: some View {
        VStack(spacing: 0) {
            // where they'll input their information, put in another file
            // at this step, will use the input to start building the Exercise

            BannerView(text: "Blank Routine")

            HStack(spacing:1) {
                Button(action: {
                    // Add action for the first button
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
                    // Add action for the second button
                }) {
                    Text("Done")
                        .font(.custom("Cairo-Regular", size: 20))
                        .frame(maxWidth: .infinity, maxHeight: 20)
                        .padding()
                        .background(Color(UIColor(red: 57/255, green: 57/255, blue: 57/255, alpha: 1)))                        .foregroundColor(.white)
                        .cornerRadius(0)
                }
            } // end of top buttons HStack
            .background(.gray)
        }
        
        // INPUT SECTION
        VStack {
            
            // Weight Section
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
            
            Button("Add Set") {
                
            }
            
            //will show sets populated
            ScrollView {
                VStack {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Text(item)
                            Spacer()
                            Image(systemName: "arrow.right.circle")
                        }
                        .padding()
                        .border(Color.gray, width: 0.5)
                    }
                }
            }
            Spacer()
            
        } // end of highest VStack
        .padding()
    } // end of Body
} // end of Struct

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

#Preview {
    SelectedExercise()
}
