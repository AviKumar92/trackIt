//
//  SingUpViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 24/08/25.
//

import UIKit

class SingUpViewController: UIViewController {

    @IBOutlet weak var btnDob: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
   
    @IBOutlet weak var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignUp.layer.cornerRadius = 10
        txtPassword.layer.cornerRadius = 10
        txtName.layer.cornerRadius = 10
        txtEmail.layer.cornerRadius = 10
        btnDob.layer.cornerRadius = 10
        
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
    }
    
    @IBAction func onClickDob(_ sender: Any) {
        openDatePicker()
    }
    
}
