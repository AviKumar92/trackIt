//
//  Habitdata+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 25/08/25.
//
//

import Foundation
import CoreData


extension Habitdata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habitdata> {
        return NSFetchRequest<Habitdata>(entityName: "Habitdata")
    }

    @NSManaged public var name: String?
    @NSManaged public var frequency: String?
    @NSManaged public var time: String?
    @NSManaged public var note: String?

}
