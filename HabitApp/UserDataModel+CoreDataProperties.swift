//
//  UserDataModel+CoreDataProperties.swift
//  HabitApp
//
//  Created by Avinash kumar on 02/09/25.
//
//

import Foundation
import CoreData


extension UserDataModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDataModel> {
        return NSFetchRequest<UserDataModel>(entityName: "UserDataModel")
    }

    @NSManaged public var dob: Date?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var bloodGroup: String?
    @NSManaged public var profileImage: Data?

}

extension UserDataModel : Identifiable {

}
