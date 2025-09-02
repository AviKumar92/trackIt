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
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let top = UIColor(red: 158/255, green: 235/255, blue: 199/255, alpha: 1)   // #9EEBC7
                let bottom = UIColor(red: 255/255, green: 241/255, blue: 166/255, alpha: 1) // #FFF1A6
                view.applyGradient(colors: [top, bottom])
    }
    func fetchData(){
        if let user = SessionManager.shared.currentUser {
//            lblName.text = user.firstName
            if let imgData = user.profileImage {
                userProfileImage.image = UIImage(data: imgData)
            } else {
                userProfileImage.image = UIImage(systemName: "person.circle")
            }
        }

    }
    
    @IBAction func onClickSignOut(_ sender: Any) {
//        if let email = UserDefaults.standard.string(forKey: "loggedInUserEmail"),
//           let user = AuthDataHelper.shared.fetchUser(email: email) {
//            print("Logged in user: \(user.firstName ?? "")")
//            Utility.setRootViewController(rootVC: LoginScreenViewController())
//        }
        SessionManager.shared.logout()
        // 2. Update UserDefaults
           UserDefaults.standard.set(false, forKey: "isLoggedIn")
           UserDefaults.standard.synchronize()
        Utility.setRootViewController(rootVC: LoginScreenViewController())
    }
    
    @IBAction func onClickEditBtn(_ sender: Any) {
        navigationController?.pushViewController(UpdateUserProfileViewController(), animated: true)
    }
    
    
}
