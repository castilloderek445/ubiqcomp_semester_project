//
//  ChooseRoutinesView.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Derek Castillo on 10/31/23.
//

import SwiftUI

struct ChooseRoutinesView: View {
    
    @Binding var rootIsActive2: Bool
        
    @State private var routineList: [RoutineList] = []
    

    var body: some View {
        List { ForEach(routineList, id: \.id) { routineListItem in
            NavigationLink(destination: ChosenRoutineReviewView(rootIsActive2: self.$rootIsActive2, routine: routineListItem.routines, routineList: self.$routineList)) {
                Text(routineListItem.routines.routineName)
                
            } // end of NavigationLink
            .isDetailLink(false)
            
        }
        .onDelete { indexSet in
            routineList.remove(atOffsets: indexSet)
            saveRoutineList()
            print("deleted a routine type beat")
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Choose Routine")
                        .font(.custom("Cairo-Regular", size: 40))
                        .foregroundColor(.white)
                        //.padding(.top, -20)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(UIColor(red: 14/255, green: 139/255, blue: 255/255, alpha: 1)), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)

        } // end of List
        .onAppear {
            loadRoutineList()
        }
        
//        .onDelete { indexSet in
//            routineList.remove(atOffsets: indexSet)
//        }
        
    } // end of Body
    
    func loadRoutineList() {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("routineList.json")
            do {
                let workoutLogData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                routineList = try decoder.decode([RoutineList].self, from: workoutLogData)
            } catch {
                print("Error loading routines list file: \(error.localizedDescription)")
            }
        }
    }
    
    func saveRoutineList() {
        do {
            let encoder = JSONEncoder()
            let workoutLogData = try encoder.encode(routineList)
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("routineList.json")
                try workoutLogData.write(to: fileURL)
            }
        } catch {
            print("Error saving to routine list file: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MainView()
}
