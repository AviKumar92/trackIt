//
//  UserProfileViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.setCornerRadius(view: userProfileImage, cornerRadius: 60)
        
    }
    
    
    
    @IBAction func onClickSignOut(_ sender: Any) {
        if let email = UserDefaults.standard.string(forKey: "loggedInUserEmail"),
           let user = AuthDataHelper.shared.fetchUser(email: email) {
            print("Logged in user: \(user.name ?? "")")
        }
        
    }
    
    @IBAction func onClickEditBtn(_ sender: Any) {
        navigationController?.pushViewController(UpdateUserProfileViewController(), animated: true)
    }
    
    
}
