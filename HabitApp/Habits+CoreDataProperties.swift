//
//  Habits+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//
//

import Foundation
import CoreData


extension Habits {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habits> {
        return NSFetchRequest<Habits>(entityName: "Habits")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var frequency: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isReminderOn: Bool
    @NSManaged public var monthlyDates: [Date]?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var time: Date?
    @NSManaged public var weeklyDays: [Int]?
    @NSManaged public var completions: NSSet?

}

// MARK: Generated accessors for completions
extension Habits {

    @objc(addCompletionsObject:)
    @NSManaged public func addToCompletions(_ value: HabitLog)

    @objc(removeCompletionsObject:)
    @NSManaged public func removeFromCompletions(_ value: HabitLog)

    @objc(addCompletions:)
    @NSManaged public func addToCompletions(_ values: NSSet)

    @objc(removeCompletions:)
    @NSManaged public func removeFromCompletions(_ values: NSSet)

}

extension Habits : Identifiable {

}
