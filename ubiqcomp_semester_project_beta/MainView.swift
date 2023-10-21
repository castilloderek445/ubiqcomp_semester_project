//
//  MainView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            AddWorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "figure.run")
                }
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    MainView()
}
