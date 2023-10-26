//
//  ubiqcomp_semester_project_betaApp.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI

@main
struct ubiqcomp_semester_project_betaApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear(){
                    // location of where the json file is
                    print(URL.documentsDirectory.path())
                }
        }
    }
}
