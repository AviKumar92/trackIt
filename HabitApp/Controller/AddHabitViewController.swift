//
//  AddHabitViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 17/08/25.
//

import UIKit
import UniformTypeIdentifiers
class AddHabitViewController: UIViewController {
   
    

    
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtvNote: UITextView!
    @IBOutlet weak var txtName: UITextField!
    var selectedHabitData:Habitdata?
    
    let data = ["Daily", "Weekly", "Monthly"]
    private let hiddenTextField = UITextField()
    var isUpdated = Bool()
    var selectedIndex = Int()
    var dataPassDelegate:DataPass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoneButtonOnKeyboard()
        addDoneButtonOnKeyboardForNote()
        Utility.setCornerRadius(view: btnTime, cornerRadius: 10)
        Utility.setCornerRadius(view: btnDaily, cornerRadius: 10)
        Utility.setCornerRadius(view: btnAdd, cornerRadius: 10)
        Utility.setCornerRadius(view: txtvNote, cornerRadius: 10)
        Utility.setCornerRadius(view: txtName, cornerRadius: 10)
        if(isUpdated){
            bindSelectedHabit()
            btnAdd.setTitle("Update", for: .normal)
        }
        else{
            btnAdd.setTitle("Add", for: .normal)
        }
       
    }
    
    func bindSelectedHabit(){
        txtName.text  = selectedHabitData?.name
        btnTime.titleLabel?.text = selectedHabitData?.time
        btnDaily.titleLabel?.text = selectedHabitData?.frequency
        txtvNote.text = selectedHabitData?.note
    }
    func addDoneButtonOnKeyboard()
        {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
            
            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            txtvNote.inputAccessoryView = doneToolbar
        }
        
       @objc func doneButtonAction()
        {
            txtvNote.resignFirstResponder()
        }
    
    func addDoneButtonOnKeyboardForNote()
        {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonActionForNote))
            
            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            txtName.inputAccessoryView = doneToolbar
        }
        
       @objc func doneButtonActionForNote()
        {
            txtName.resignFirstResponder()
        }
//    private func setupPicker() {
//        
//        frequencyPickerView.dataSource = self
//        frequencyPickerView.delegate = self
//        
//        btnTime.setTitle("Select your time", for: .normal)
//        btnTime.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        frequencyPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
//       }

    
    func openDatePicker() {
        let alert = UIAlertController(title: "Pick a Date", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)

                let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
                datePicker.preferredDatePickerStyle = .wheels
//        datePicker.minimumDate = Calendar.current.date(byAdding: , value: 7, to: Date())

                alert.view.addSubview(datePicker)
                datePicker.frame = CGRect(x: 0, y: 40, width: alert.view.bounds.width - 20, height: 200)

                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm a"
                    let selectedDate = formatter.string(from: datePicker.date)
                    print(selectedDate)
                    self?.btnTime.setTitle(selectedDate, for: .normal)
                    
                }))

                present(alert, animated: true)
    }
    
    func openFrequencyPicker() {
        let alert = UIAlertController(title: "Select Option", message: "\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
                
                let picker = UIPickerView(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width - 20, height: 150))
                picker.dataSource = self
                picker.delegate = self
                alert.view.addSubview(picker)
                
                let ok = UIAlertAction(title: "Done", style: .default) { _ in
                    let selectedRow = picker.selectedRow(inComponent: 0)
                    let selectedItem = self.data[selectedRow]
                    self.btnDaily.setTitle(selectedItem, for: .normal)
                }
                alert.addAction(ok)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                
                present(alert, animated: true)
    }
    
    @IBAction func onClickAddBtn(_ sender: Any) {
        let name = txtName.text ?? ""
        let time = btnTime.titleLabel?.text ?? ""
        let frequency = btnDaily.titleLabel?.text ?? ""
        let note = txtvNote.text ?? ""
        
        let savedData = ["name": name,
                         "time" : time,
                         "frequency": frequency,
                         "note": note]
        
        if(isUpdated){
            DataBaseHelper.sharedInstance.editData(object: savedData as! [String:String], index: selectedIndex)
            navigationController?.popViewController(animated: true)
        }else{
            DataBaseHelper.sharedInstance.save(object: savedData)
            dismiss(animated: true)
        }
        
        dataPassDelegate?.refreshPage()
    }
    
 
    @IBAction func onClickDaily(_ sender: Any) {
        openFrequencyPicker()
    }
    
    @IBAction func onClickTime(_ sender: Any) {
        openDatePicker()
    }
    
}

extension AddHabitViewController: UIPickerViewDataSource,UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1  // columns
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return data.count
        }

        // For default text
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return data[row]
        }

        // For custom view (font, color, etc.)
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let label = UILabel()
            label.text = data[row]
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            label.textColor = .systemBlue
            return label
        }

        // On selection
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print("Selected: \(data[row])")
        }
}
