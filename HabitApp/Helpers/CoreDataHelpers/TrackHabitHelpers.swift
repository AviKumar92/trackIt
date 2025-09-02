//
//  TrackHabitHelpers.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//

import CoreData

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
    static func getCompletionCounts(forLastNDays days: Int) -> [(date: Date, count: Int)] {
        var results: [(date: Date, count: Int)] = []
        let calendar = Calendar.current
        
        for i in 0..<days {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let startOfDay = calendar.startOfDay(for: date)
                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
                
                // Fetch completions for this day
                let fetchRequest: NSFetchRequest<HabitLog> = HabitLog.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
                
                if let ctx = DataBaseHelper.sharedInstance.context{
                    do {
                        let completions = try ctx.fetch(fetchRequest)
                        results.append((date: date, count: completions.count))
                    } catch {
                        print("Error fetching completions: \(error)")
                    }
                }
            }
        }
        
        // Reverse to make chronological order
        return results.reversed()
    }

}

extension DateFormatter {
    static let shortWeekday: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "E" // Mon, Tue...
        return df
    }()
}
