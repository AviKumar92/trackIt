//
//  HabitExtensions.swift
//  HabitApp
//
//  Created by Avinash kumar on 30/08/25.
//

import Foundation

enum FrequencyType: String {
    case daily
    case weekly
    case monthly
}

extension Habits {
    var frequencyData: FrequencyType {
        get {
            FrequencyType(rawValue: frequency ?? "") ?? .daily
        }
        set {
            frequency = newValue.rawValue
        }
    }

    var scheduleDescription: String {
        switch frequencyData {
        case .daily: return "Daily at \(timeString())"
        case .weekly:
            let days = (weeklyDays ?? []).map { weekdayName(from: $0) }
            return "Weekly on \(days.joined(separator: ", ")) at \(timeString())"
        case .monthly:
            let df = DateFormatter()
            df.dateFormat = "MMM d"
            let dates = (monthlyDates ?? []).sorted().map { df.string(from: $0) }
            return "Monthly on \(dates.joined(separator: ", ")) at \(timeString())"
        }
    }

    func timeString() -> String {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .none
        return df.string(from: time ?? Date.now)
    }

    private func weekdayName(from index: Int) -> String {
        let symbols = Calendar.current.weekdaySymbols // Sunday = 0
        return symbols[index % symbols.count]
    }
}

