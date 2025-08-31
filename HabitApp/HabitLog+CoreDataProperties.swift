//
//  HabitLog+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//
//

import Foundation
import CoreData


extension HabitLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HabitLog> {
        return NSFetchRequest<HabitLog>(entityName: "HabitLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var habit: Habits?

}

extension HabitLog : Identifiable {

}
