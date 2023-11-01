//
//  ProfileAlertController.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Justin Jose on 10/30/23.
//

import SwiftUI
import UIKit

struct WeightAlertController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool // Alert visibility
    @Binding var enteredWeight: String // Stores entered weight
    var onConfirm: (() -> Void)? // Optional closure
    
    // Creates a dummy UIViewController since UIAlertController is the main focus
    func makeUIViewController(context: UIViewControllerRepresentableContext<WeightAlertController>) -> UIViewController {
        return UIViewController()
    }
    
    // Called when there's a need to update the UIViewController (UIAlertController in this case)
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<WeightAlertController>) {
        guard context.coordinator.didAttemptToShowAlert == false else { return }
        // Presents the alert when isPresented is true
        if isPresented {
            // Creating the alert controller
            let alert = UIAlertController(title: "How much do you weigh?", message: "Enter your weight in pounds.", preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Enter weight"
                textField.keyboardType = .numberPad // Using number pad for input
            }
            // Ok button action
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let textField = alert.textFields?.first, let text = textField.text, let weight = Double(text) {
                    self.enteredWeight = String(weight)
                    self.onConfirm?()
                } else {
                    // Showing an error if the input is invalid
                    let errorAlert = UIAlertController(title: "Error", message: "Please enter a valid weight.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    uiViewController.present(errorAlert, animated: true, completion: nil)
                }
                // Resetting states after action
                self.isPresented = false
                context.coordinator.didAttemptToShowAlert = false
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.isPresented = false
                context.coordinator.didAttemptToShowAlert = false  // And reset the flag here too
            }))
            // Presents alert
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: nil)
            }
            context.coordinator.didAttemptToShowAlert = true
        }
    }
    
    // Creates Coordinator object to manage interactions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Manages states and interactions
    class Coordinator {
        var didAttemptToShowAlert = false
        var parent: WeightAlertController
        
        init(_ parent: WeightAlertController) {
            self.parent = parent
        }
    }
}

struct NameAlertController: UIViewControllerRepresentable {
    var title: String
    var message: String
    @Binding var isPresented: Bool
    @Binding var enteredText: String
    var onConfirm: () -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NameAlertController>) -> UIViewController {
        return UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NameAlertController>) {
        guard context.coordinator.didAttemptToShowAlert == false else { return }
        
        if isPresented {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "Enter name"
                textField.text = self.enteredText
            }
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                if let textField = alert.textFields?.first {
                    self.enteredText = textField.text ?? ""
                    self.onConfirm()
                }
                self.isPresented = false
                context.coordinator.didAttemptToShowAlert = false  // Reset the flag here
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.isPresented = false
                context.coordinator.didAttemptToShowAlert = false  // And reset the flag here too
            }))
            DispatchQueue.main.async {
                uiViewController.present(alert, animated: true, completion: nil)
            }
            context.coordinator.didAttemptToShowAlert = true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator {
        var didAttemptToShowAlert = false
        var parent: NameAlertController
        
        init(_ parent: NameAlertController) {
            self.parent = parent
        }
    }
}
