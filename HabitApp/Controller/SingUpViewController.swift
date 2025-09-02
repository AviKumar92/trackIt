//
//  SingUpViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 24/08/25.
//

import UIKit
import IQKeyboardManagerSwift
class SingUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var btnDob: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    var validateobj = Validation()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 10
        txtPassword.layer.cornerRadius = 10
        txtName.layer.cornerRadius = 10
        txtEmail.layer.cornerRadius = 10
        btnDob.layer.cornerRadius = 10
        txtName.delegate = self
                txtEmail.delegate = self
                txtPassword.delegate = self
                
                // Add Done button for all textfields
                addDoneButtonOnKeyboard(for: txtName)
                addDoneButtonOnKeyboard(for: txtEmail)
                addDoneButtonOnKeyboard(for: txtPassword)
        
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
           view.endEditing(true) // hides keyboard for all textfields
       }
       
       // Optional: Hide keyboard when pressing return
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
    
    func openDatePicker() {
        let alert = UIAlertController(title: "Pick a Date", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        
        alert.view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 40, width: alert.view.bounds.width - 20, height: 200)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            let selectedDate = formatter.string(from: datePicker.date)
            print(selectedDate)
            self?.btnDob.setTitle(selectedDate, for: .normal)
            
        }))
        
        present(alert, animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let isvalidate = validateUserData()
        if (isvalidate == true){
            guard let name = txtName.text, !name.isEmpty,
                      let email = txtEmail.text, !email.isEmpty,
                      let password = txtPassword.text, !password.isEmpty,
                      let dobText = btnDob.title(for: .normal), dobText != "Select DOB"
                else {
                    Utility.showAlert(Messeage: "All fields are required", ParentViewController: self)
                    return
                }
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                guard let dob = formatter.date(from: dobText) else { return }
                
                let success = AuthDataHelper.shared.saveUser(name: name, email: email, dob: dob, password: password)
                
                if success {
                    Utility.showAlert(Messeage: "Signup Successful", ParentViewController: self)
                } else {
                    Utility.showAlert(Messeage: "User already exists", ParentViewController: self)
                }
        }
    }
    
    @IBAction func onClickDob(_ sender: Any) {
        openDatePicker()
    }
    
    func validateUserData() -> Bool{
        if (validateobj.validateName(Name: txtName.text!)){
            if (validateobj.validateEmail(Email: txtEmail.text!)){
                if (validateobj.validatePassword(Password: txtPassword.text!)){
                    return true
                }
                        else {
                            //                        lblEmailCheck.isHidden = false
                            //                        lblEmailCheck.text = "Password must be 6 characters"
                            Utility.showAlert(Messeage: "Password must be 8 characters", ParentViewController: self)
                            return false
                        
                    }
                }
                else{
                    //                    lblEmailCheck.isHidden = false
                    //                    lblEmailCheck.text = "Password must be 6 characters"
                    Utility.showAlert(Messeage: "Please enter the email in correct format", ParentViewController: self)
                    return false
                }
            }
            else {
                //
                Utility.showAlert(Messeage: "Please enter Name", ParentViewController: self)
                return false
            }
            
            
        }
        
    }

