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
            user.firstName = name
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
                SessionManager.shared.currentUser = user
                return user.password == password
            }
            return false
        }
    
    func updateUser(email: String, firstName: String?, lastName: String?, bloodGroup: String?, dob: Date?, profileImage: UIImage?) -> Bool {
        guard let user = fetchUser(email: email) else { return false }
        
        if let firstName = firstName { user.firstName = firstName }
        if let lastName = lastName { user.lastName = lastName }
        if let bloodGroup = bloodGroup { user.bloodGroup = bloodGroup }
        if let dob = dob { user.dob = dob }
        if let profileImage = profileImage {
            user.profileImage = profileImage.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Error updating user: \(error)")
            return false
        }
    }

    // MARK: - Save Context
        func saveContext() {
            if context.hasChanges {
                do {
                    try context.save()
                    print("✅ Core Data save successful")
                } catch {
                    let nserror = error as NSError
                    print("❌ Core Data save failed: \(nserror), \(nserror.userInfo)")
                }
            }
        }
}
