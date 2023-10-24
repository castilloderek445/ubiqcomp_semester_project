//
//  AddWorkoutView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct AddWorkoutView: View {
    
    var body: some View {
        
        VStack {
            
            VStack(spacing:0) {
                BannerView(text: "Add a Workout")
                DateBannerView()
            }
            Spacer()

            // Buttons
            VStack(spacing: 20) {
                
                Button(action: {
                    // Action for "Choose Routine" button
                }) {
                    Text("Choose Routine")
                        .font(.custom("Cairo-Regular", size: 32))
                        .tracking(-0.24)
                }
                .frame(width: 289, height: 97)
                .background(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                .cornerRadius(12)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 4)
                
                
                NavigationView {
                    NavigationLink(destination: ExerciseListView()) {
                        Text("New Routine")
                            .font(.custom("Cairo-Regular", size: 32))
                            .tracking(-0.24)
                    }
                    .frame(width: 289, height: 97)
                    .background(Color(UIColor(red: 254/255, green: 125/255, blue: 14/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 4)
                }
                
            }
            
            Spacer()
            Spacer()
        }
    }
}




#Preview {
    AddWorkoutView()
}
