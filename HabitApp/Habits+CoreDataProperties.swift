//
//  Habits+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 30/08/25.
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
    @NSManaged public var monthlyDates: [Int]?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var time: Date?
    @NSManaged public var weeklyDays: [Int]?

}

extension Habits : Identifiable {

}
