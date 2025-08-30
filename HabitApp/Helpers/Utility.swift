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
    
    static  func setCornerRadius(view:UIView,cornerRadius:CGFloat){
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
    
    /// Random pastel color (soft, high brightness, low saturation)
   static func randomPastelColor() -> UIColor {
        let hue: CGFloat        = .random(in: 0...1)          // any hue
        let saturation: CGFloat = .random(in: 0.20...0.40)    // low-ish
        let brightness: CGFloat = .random(in: 0.92...1.00)    // bright
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

}
