//
//  AddWorkoutView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct AddWorkoutView: View {
    
    @State private var rootIsActive: Bool = false
    @State private var rootIsActive2: Bool = false
    @State private var newRoutineIsActive: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            
            // MARK: highest VStack
            VStack {
                
                // MARK: Banner
                HStack(spacing:1) {
                    DateBannerView()
                    
                } // end of top buttons HStack
                .background(.gray)
                
                Spacer()

                // MARK: Buttons VStack
                VStack(spacing: 70) {
                    
                    // MARK: Choose Routine Button
                    NavigationLink(destination: ChooseRoutinesView(rootIsActive2: self.$rootIsActive2), isActive: self.$rootIsActive2) {
                        Button(action: {
                            self.rootIsActive2 = true
                        }) {
                            Text("Choose Routine")
                                .font(.custom("Cairo-Regular", size: 32))
                                .tracking(-0.24)
                        }

                    }
                    .isDetailLink(false)
                    .frame(width: 289, height: 97)
                    .background(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 4)
                    
                    // MARK: New Routine Button
                    NavigationLink(destination: ExerciseListView(rootIsActive: self.$rootIsActive, newRoutineIsActive: self.$newRoutineIsActive), isActive: self.$rootIsActive) {
                        Button(action: {
                            self.rootIsActive = true
                            self.newRoutineIsActive = true}) {
                            Text("New Routine")
                                .font(.custom("Cairo-Regular", size: 32))
                                .tracking(-0.24)
                        }

                    }
                    .isDetailLink(false)
                    .frame(width: 289, height: 97)
                    .background(Color(UIColor(red: 254/255, green: 125/255, blue: 14/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                    .cornerRadius(12)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 4)
                } // end of Buttons VStack
                Spacer()
                Spacer()
            } // end of VStack
                
            // MARK: navbar stuff
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Add a Workout")
                            .font(.custom("Cairo-Regular", size: 40))
                            .foregroundColor(.white)
                            //.padding(.top, -20)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            
        } // end of navigationview
        
        
    }
}


#Preview {
    MainView()
}
