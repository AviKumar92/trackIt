//
//  UserDataModel+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//
//

import Foundation
import CoreData


extension UserDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataModel> {
        return NSFetchRequest<UserDataModel>(entityName: "UserDataModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var dob: Date?
    @NSManaged public var password: String?

}

extension UserDataModel : Identifiable {

}
