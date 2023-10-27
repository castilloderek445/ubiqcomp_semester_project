//
//  MainView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

struct MainView: View {
    
    @State private var defaultPage = 2
    
    var body: some View {
        TabView(selection: $defaultPage) {
            AddWorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "figure.run")
                }.tag(1)
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }.tag(2)
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }.tag(3)
        }
    }
}



#Preview {
    MainView()
}
