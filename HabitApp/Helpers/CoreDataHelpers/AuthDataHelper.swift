//
//  AuthDataHelper.swift
//  HabitApp
//
//  Created by Avinash kumar on 31/08/25.
//

import Foundation
import CoreData

class AuthDataHelper {
    static let shared = AuthDataHelper()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        private init() {}
        
        // Save new user
        func saveUser(name: String, email: String, dob: Date, password: String) -> Bool {
            // Check if user already exists
            if fetchUser(email: email) != nil {
                return false // user already exists
            }
            
            let user = UserDataModel(context: context)
            user.name = name
            user.email = email
            user.dob = dob
            user.password = password
            
            do {
                try context.save()
                return true
            } catch {
                print("Error saving user: \(error)")
                return false
            }
        }
        
        // Fetch user by email
        func fetchUser(email: String) -> UserDataModel? {
            let request: NSFetchRequest<UserDataModel> = UserDataModel.fetchRequest()
            request.predicate = NSPredicate(format: "email == %@", email)
            
            do {
                let result = try context.fetch(request)
                return result.first
            } catch {
                print("Error fetching user: \(error)")
                return nil
            }
        }
        
        // Validate login
        func validateUser(email: String, password: String) -> Bool {
            if let user = fetchUser(email: email) {
                return user.password == password
            }
            return false
        }
}
