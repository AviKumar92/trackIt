//
//  LoginScreenViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit

class LoginScreenViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPasssword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func onClickBtn(_ sender: Any) {
        Utility.setRootViewController(rootVC: HomeTabBar())
    }
    
}
