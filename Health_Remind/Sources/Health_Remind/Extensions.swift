//
//  File.swift
//  
//
//  Created by Greem on 7/30/24.
//

import Foundation

extension Date {
    var startOfDay: Date { Calendar.current.startOfDay(for: self) }
    var aWeekAgo: Date {
        guard let aWeekAgoDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date()) else {
            fatalError("Failed to calculate a week ago date")
        }
        return aWeekAgoDate
    }
}
