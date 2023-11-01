//
//  UIImagePickerController.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Justin Jose on 11/1/23.
//

import SwiftUI

// Allows users to select an image from their photo library to use as their profile photo
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage? // Selected image which is passed back to ProfileView
    @Binding var isPresented: Bool // Image picker visibility
    var sourceType: UIImagePickerController.SourceType = .photoLibrary // Sends users to their photo library
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType // Source of image
        picker.delegate = context.coordinator // Sets delegate to handle picker events
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    // Creates the coordinator which acts as a bridge between the UIImagePickerController and SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // The coordinator class that acts as a delegate for the UIImagePickerController
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        // Initializes the coordinator with a reference to the ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // Handles when an image is picked
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            // Dismisses the image picker
            parent.isPresented = false
        }
        
        // Handles cancellation of the image picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismisses the image picker
            parent.isPresented = false
        }
    }
}
