//
//  ActivityViewController.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Justin Jose on 11/1/23.
//

import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {
    var activityItems: [Any] // Item(s) to share
    var applicationActivities: [UIActivity]? = nil // Activities for the share sheet
    
    // Initializes the activity view controller with the items to be shared
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    // Required by UIViewControllerRepresentable, but not used in this context
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {
        
    }
}
