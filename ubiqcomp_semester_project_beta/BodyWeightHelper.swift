//
//  BodyWeightHelper.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Justin Jose on 11/1/23.
//

import Foundation

// Date Extension for Removing Time Component
extension Date {
    // Normalizes the date by removing the time component, leaving only year, month, and day
    func normalized() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }
}

// Represents a weight log entry for encoding into JSON.
struct WeightLogEntry: Codable {
    var date: String
    var weight: String
}

// Helper structure for handling body weight logs.
struct BodyWeightHelper {
    // Converts a dictionary of weight logs into JSON data.
    // Parameters: Returns: A `Data` object containing the JSON representation of the logs, or `nil` if an error occurs.
    static func convertLogsToJSON(_ weightLogs: [Date: Double]) -> Data? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        // Convert each weight log entry to a `WeightLogEntry` object
        let weightLogEntries = weightLogs.map { (key, value) -> WeightLogEntry in
            return WeightLogEntry(date: dateFormatter.string(from: key), weight: "\(value) lb")
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(weightLogEntries)
            return data
        } catch {
            print("Error encoding logs: \(error)")
            return nil
        }
    }
    
    // Formats a given date into a string
    static func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
