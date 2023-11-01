//
//  BodyWeightLog.swift
//  ubiqcomp_semester_project_beta
//
//  Created by Justin Jose on 11/1/23.
//

import Foundation

// Log entry for bodyweight tracking
struct BodyWeightLog: Codable {
    var logDate: Date // Date of log entry
    var weight: Double // Recorded weight of log entry
}
