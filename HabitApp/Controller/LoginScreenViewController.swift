//
//  LoginScreenViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit

class LoginScreenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtPasssword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  Utility.setHorizontalBlueGradientColor(view: view)
        Utility.setCornerRadius(view: btnSignUp, cornerRadius: 10)
        Utility.setCornerRadius(view: btnLogin, cornerRadius: 10)
        txtEmail.delegate = self
                txtPasssword.delegate = self
                
                // Add Done button to both textfields
                addDoneButtonOnKeyboard(for: txtEmail)
                addDoneButtonOnKeyboard(for: txtPasssword)
        addWaveBackground(to: view)

    }
    
    func addWaveBackground(to view: UIView) {
        let width = view.bounds.width
        let height = view.bounds.height

        // Orange background (top)
        let backgroundLayer = CALayer()
        backgroundLayer.frame = view.bounds
        backgroundLayer.backgroundColor = UIColor(red: 255/255, green: 105/255, blue: 97/255, alpha: 1).cgColor // Orange-ish
        view.layer.insertSublayer(backgroundLayer, at: 0)

        // White wave shape at the bottom
        let wavePath = UIBezierPath()
        wavePath.move(to: CGPoint(x: 0, y: height * 0.75))
        wavePath.addCurve(to: CGPoint(x: width, y: height * 0.75),
                          controlPoint1: CGPoint(x: width * 0.25, y: height * 0.60),
                          controlPoint2: CGPoint(x: width * 0.75, y: height * 0.90))
        wavePath.addLine(to: CGPoint(x: width, y: height))
        wavePath.addLine(to: CGPoint(x: 0, y: height))
        wavePath.close()

        let waveLayer = CAShapeLayer()
        waveLayer.path = wavePath.cgPath
        waveLayer.fillColor = UIColor.white.cgColor

        view.layer.insertSublayer(waveLayer, above: backgroundLayer)
    }


    
    func addDoneButtonOnKeyboard(for textField: UITextField) {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
            
            toolbar.items = [flexSpace, doneButton]
            textField.inputAccessoryView = toolbar
        }
        
        @objc func doneTapped() {
            view.endEditing(true) // dismisses keyboard
        }
        
        // Optional: close keyboard when pressing return
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    @IBAction func onClickBtn(_ sender: Any) {
        guard let email = txtEmail.text, !email.isEmpty,
               let password = txtPasssword.text, !password.isEmpty
         else {
             Utility.showAlert(Messeage: "Please enter email and password", ParentViewController: self)
             return
         }
         
         let isValid = AuthDataHelper.shared.validateUser(email: email, password: password)
         
         if isValid {
             UserDefaults.standard.set(email, forKey: "loggedInUserEmail")
                 UserDefaults.standard.set(true, forKey: "isLoggedIn")
                 UserDefaults.standard.synchronize()
             
             
             Utility.showAlert(Messeage: "Login Successful", ParentViewController: self)
             Utility.setRootViewController(rootVC: HomeTabBar())
             // Navigate to Home Screen
         } else {
             Utility.showAlert(Messeage: "Invalid email or password", ParentViewController: self)
         }
        
       
    }
    
    @IBAction func onClickSignUpBtn(_ sender: Any) {
        let vc = SingUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
