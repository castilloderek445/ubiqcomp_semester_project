//
//  ProfileView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/21/23.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct ProfileView: View {
    // State variables to manage UI and data
    @State private var selectedBodyPart: String? = nil // Selected body part
    @State private var selectedDate: Date = Date() // Current date selected in DatePicker
    @State private var isCalendarShown: Bool = false // Flag to toggle calendar / DatePicker visibility
    @State private var enteredWeight: String = "" // Entered weight value
    @State private var weightLogs: [Date: Double] = [:] // Dictionary for weight log, maps dates to recorded weight
    @State private var isPresented: Bool = false // Weight alert visibility
    @State private var name: String = "Edit Name" // Default name, editable
    @State private var enteredName: String = "" // New entered name
    @State private var showingNameEditAlert: Bool = false // Name edit alert visibility
    @State private var showingActivityViewController = false // Share sheet visibility
    @State private var activityItems: [Any] = [] // For exportable JSON
    @State private var selectedImage: UIImage? = nil // User-selected profile image
    @State private var showingImagePicker = false // Image picker interface visibility
    
    // Body parts array for Personal Records
    let bodyParts: [String] = ["Chest", "Shoulders", "Back", "Biceps", "Triceps"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                VStack(spacing: 20) {
                    HStack {
                        // Profile image view with tap gesture to change image
                        Image(uiImage: selectedImage ?? UIImage(systemName: "person.crop.circle.fill")!)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(selectedImage == nil ? .blue : .clear)
                            .onTapGesture {
                                self.showingImagePicker = true // Show image picker on tap
                            }
                            .clipShape(Circle()) // Circular frame for profile image
                        
                        // Button to trigger name edit alert dialog
                        Button(action: {
                            self.showingNameEditAlert = true
                        }) {
                            Text(name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding(.leading, 10)
                        }
                        // Name alert controller binding for editing name
                        .background(NameAlertController(title: "Edit Name", message: "Enter your name.", isPresented: $showingNameEditAlert, enteredText: $enteredName) {
                            self.name = self.enteredName
                        })
                        
                        
                        
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        // Bodyweight display and management section
                        HStack {
                            // Bodyweight section
                            Text("Bodyweight")
                                .font(.custom("Cairo-Regular", size: 32))
                                .fontWeight(.semibold)
                                .foregroundColor(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)))
                            
                            Spacer()
                            
                            // Add weight button with alert controller for entering weight
                            Button(action: {
                                self.isPresented = true
                            }) {
                                Text("Add")
                                    .font(.custom("Cairo-Regular", size: 24))
                                    .foregroundColor(Color(UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)))
                            }
                            .background(WeightAlertController(isPresented: $isPresented, enteredWeight: $enteredWeight, onConfirm: {
                                weightLogs[selectedDate] = Double(enteredWeight)
                            }))
                        }
                        
                        // Button for DatePicker / calendar
                        Button(action: {
                            isCalendarShown.toggle()
                        }) {
                            HStack {
                                // Displays selected date on calendar and corresponding weight logged for that day (defaults are today's date and "0 lbs" respectively)
                                Text("\(BodyWeightHelper.formattedDate(selectedDate)): \(String(format: "%.0f", weightLogs[selectedDate.normalized(), default: 0.0])) lb")
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        }
                        
                        // Links the selected date to the DatePicker and updates the entered weight when the date changes
                        let dateBinding = Binding<Date>(
                            get: {
                                self.selectedDate
                            },
                            set: {
                                self.selectedDate = $0
                                self.enteredWeight = String(format: "%.0f", self.weightLogs[$0.normalized(), default: 0.0])
                                print("Selected Date: \(self.selectedDate.normalized()), Entered Weight: \(self.enteredWeight)")
                            }
                        )
                        
                        if isCalendarShown {
                            DatePicker("", selection: dateBinding, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Personal Records section, unfinished
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Personal Records")
                            .font(.custom("Cairo-Regular", size: 32))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)))
                        
                        Menu {
                            ForEach(bodyParts, id: \.self) { bodyPart in
                                Button(action: {
                                    selectedBodyPart = bodyPart
                                    //
                                }) {
                                    Text(bodyPart)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedBodyPart ?? "Choose body part: ")
                                    .font(.body)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        }
                        
                    }.padding(.horizontal, 20)
                }
                
                // Export button to save and share bodyweight log as a JSON file
                Button("Export Bodyweight Log") {
                    // Converts weightLogs dictionary to JSON and handles file creation
                    if let jsonData = BodyWeightHelper.convertLogsToJSON(weightLogs) {
                        let fileName = "\(name) Weight Log.json"
                        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
                        do {
                            try jsonData.write(to: tempURL)
                            self.activityItems = [tempURL]
                            self.showingActivityViewController = true
                        } catch {
                            print("Failed to write JSON data: \(error)")
                        }
                    }
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(radius: 3)
                .sheet(isPresented: $showingActivityViewController) {
                    ActivityViewController(activityItems: self.activityItems, applicationActivities: nil)
                }
            }
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
            }
        }
        .background(WeightAlertController(isPresented: $isPresented, enteredWeight: $enteredWeight, onConfirm: {
            if Double(enteredWeight) != nil {
                weightLogs[selectedDate.normalized()] = Double(enteredWeight)
                print("Entire weightLogs dictionary: \(weightLogs)")
            }
        }))
    }
}

#Preview {
    ProfileView()
}
