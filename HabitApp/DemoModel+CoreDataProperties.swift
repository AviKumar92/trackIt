//
//  DemoModel+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 30/08/25.
//
//

import Foundation
import CoreData


extension DemoModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DemoModel> {
        return NSFetchRequest<DemoModel>(entityName: "DemoModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var rollNo: String?

}

extension DemoModel : Identifiable {

}
