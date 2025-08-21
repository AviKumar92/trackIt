//
//  Utility.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import Foundation
import UIKit

class Utility {
    static func setRootViewController(rootVC: UIViewController) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate : SceneDelegate = (scene?.delegate as? SceneDelegate) {
            sceneDelegate.window?.rootViewController = rootVC
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
}
