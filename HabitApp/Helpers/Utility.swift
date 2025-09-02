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

    static func showAlert(Messeage:String,ParentViewController:UIViewController,HeaderTitle:String = "Habit") -> Void {
        let alert = UIAlertController(title: HeaderTitle, message: Messeage, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //            ParentViewController.navigationController?.popViewController(animated: true)
        }))
        
        ParentViewController.present(alert, animated: true, completion: nil)
    }
    
//    static func setHorizontalBlueGradientColor(view: UIView) {
////        removeExistingGradientLayers(from: view)
//
//        let gradientLayer = CAGradientLayer()
//        var updatedFrame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
//        gradientLayer.frame = updatedFrame
//        gradientLayer.colors = [UIColor(red: 133/255, green: 189/255, blue: 221/255, alpha: 1).cgColor, UIColor(red: 73/255, green: 90/255, blue: 169/255, alpha: 1).cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        view.layer.insertSublayer(gradientLayer, at: 0)
//    }
    
    static func setHorizontalBlueGradientColor(view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        
        gradientLayer.colors = [
//            UIColor(red: 35/255, green: 31/255, blue: 38/255, alpha: 1).cgColor,   // Dark shade (Top)
            UIColor(red: 73/255, green: 90/255, blue: 169/255, alpha: 1).cgColor,  // Medium blue/purple
            UIColor(red: 133/255, green: 189/255, blue: 221/255, alpha: 1).cgColor // Light cyan/blue (Bottom)
        ]
        
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        // Top → Bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.5, y: 1.0)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
