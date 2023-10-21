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
                
                Button(action: {
                    // Action for "New Routine" button
                }) {
                    Text("New Routine")
                        .font(.custom("Cairo-Regular", size: 32))
                        .tracking(-0.24)
                }
                .frame(width: 289, height: 97)
                .background(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1))                .edgesIgnoringSafeArea(.top))
                .cornerRadius(12)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.30), radius: 4, x: 0, y: 4)
            }
            
            Spacer()
        }
    }
}

struct BannerView: View {
    let text: String

    var body: some View {
        ZStack {
            Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1))                
                .edgesIgnoringSafeArea(.top)
            Text(text)
                //.font(.title)
                .font(.custom("Cairo-Regular", size: 40))
                .foregroundColor(.white)
                .padding(.top, -20)
        }
        .frame(height: 80)
    }
}


struct DateBannerView: View {
    let currentDate: Date
    let dateString: String

    init() {
        currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateString = dateFormatter.string(from: currentDate)
    }

    var body: some View {
        ZStack {
            Color(UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1))                
                .edgesIgnoringSafeArea(.top)
            Text(dateString)
                .font(.custom("Cairo-Regular", size: 20))
                .foregroundColor(Color(UIColor(red: 0x3C/255, green: 0x3C/255, blue: 0x43/255, alpha: 0.6)))
                .lineSpacing(18)
                .foregroundColor(.white)
        }
        .frame(height: 65)
    }
}


#Preview {
    AddWorkoutView()
}
