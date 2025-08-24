//
//  SingUpViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 24/08/25.
//

import UIKit

class SingUpViewController: UIViewController {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 10
        txtPassword.layer.cornerRadius = 10
        txtName.layer.cornerRadius = 10
        txtEmail.layer.cornerRadius = 10
        dobView.layer.cornerRadius = 10
        
    }


    @IBAction func onClickSignUp(_ sender: Any) {
    }
    

}
