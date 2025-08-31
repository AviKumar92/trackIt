//
//  TrackHabitHelpers.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//

class TrackHabitHelpers {
    
    static let cal = Calendar.current

   static func startOfDay(_ date: Date) -> Date {
        cal.startOfDay(for: date)
    }

    static func endOfDay(_ date: Date) -> Date {
        cal.date(byAdding: .day, value: 1, to: startOfDay(date))!
    }

    static func weekdayMondayIsOne(_ date: Date) -> Int {
        // system: Sun=1…Sat=7 → we want Mon=1…Sun=7
        let sys = cal.component(.weekday, from: date)
        return (sys + 5) % 7 + 1
    }

    static func dayOfMonth(_ date: Date) -> Int {
        cal.component(.day, from: date)
    }

}
