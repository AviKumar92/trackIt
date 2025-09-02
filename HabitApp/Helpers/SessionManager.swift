//
//  SessionManager.swift
//  HabitApp
//
//  Created by Avinash kumar on 02/09/25.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()
    
    var currentUser: UserDataModel?   // This will be your Core Data User object
    private init() {}
    
    func logout() {
           currentUser = nil
       }
}
