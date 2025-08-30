//
//  AddHabitViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 17/08/25.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData

class AddHabitViewController: UIViewController {
    
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var btnMonthly: UIButton!
    @IBOutlet weak var btnWeekly: UIButton!
    @IBOutlet weak var weeklyCollectionView: UICollectionView!
    @IBOutlet weak var montlyView: UIView!
    @IBOutlet weak var weeklyView: UIView!
    
    @IBOutlet weak var frequecyContainerStack: UIStackView!
    
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var btnDaily: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtvNote: UITextView!
    @IBOutlet weak var txtName: UITextField!
    
    var selectedHabitData:Habits?
    var weekDay = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
    let data = ["Daily", "Weekly", "Monthly"]
    private let hiddenTextField = UITextField()
    var isUpdated = Bool()
    var selectedIndex = Int()
    var selectedTimeForHabit: Date?
    var dataPassDelegate:DataPass?
    private var selectedWeekdays: Set<Int> = []
    private var selectedMonthDates: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        addDoneButtonOnKeyboard()
        addDoneButtonOnKeyboardForNote()
        Utility.setCornerRadius(view: btnTime, cornerRadius: 10)
        Utility.setCornerRadius(view: btnDaily, cornerRadius: 10)
        Utility.setCornerRadius(view: btnAdd, cornerRadius: 10)
        Utility.setCornerRadius(view: txtvNote, cornerRadius: 10)
        Utility.setCornerRadius(view: txtName, cornerRadius: 10)
        Utility.setCornerRadius(view: btnWeekly, cornerRadius: 10)
        Utility.setCornerRadius(view: btnMonthly, cornerRadius: 10)
        weeklyCollectionView.delegate = self
        weeklyCollectionView.dataSource = self
        frequecyContainerStack.isHidden = true
        if(isUpdated){
            bindSelectedHabit()
            btnAdd.setTitle("Update", for: .normal)
        }
        else{
            btnAdd.setTitle("Add", for: .normal)
        }
        
        resetButtonColors()
        btnDaily.backgroundColor = .green
    }
    
    func registerCell(){
        weeklyCollectionView.allowsMultipleSelection = true
        let cell = UINib(nibName: "WeekDayCollectionViewCell", bundle: nil)
        weeklyCollectionView.register(cell, forCellWithReuseIdentifier: "Cell")
        
    }
    
    func resetButtonColors() {
        btnDaily.backgroundColor = .white
        btnWeekly.backgroundColor = .white
        btnMonthly.backgroundColor = .white
    }
    
    func bindSelectedHabit(){
//        txtName.text  = selectedHabitData?.name
//        btnTime.titleLabel?.text = selectedHabitData?.time
//        btnDaily.titleLabel?.text = selectedHabitData?.frequency
       // txtvNote.text = selectedHabitData?.note
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
        
        func openDatePicker() {
            let alert = UIAlertController(title: "Pick a Date", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .time
            datePicker.preferredDatePickerStyle = .wheels
            
            alert.view.addSubview(datePicker)
            datePicker.frame = CGRect(x: 0, y: 40, width: alert.view.bounds.width - 20, height: 200)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
                let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm a"
                let selectedDate = formatter.string(from: datePicker.date)
                print(selectedDate)
                self?.btnTime.setTitle(selectedDate, for: .normal)
                self?.selectedTimeForHabit = datePicker.date
                
            }))
            
            present(alert, animated: true)
        }
        
        
        
        @IBAction func onClickAddBtn(_ sender: Any) {
            
            let name = txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else {
            let a = UIAlertController(title: "Missing name", message: "Please enter a habit name.", preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default))
            present(a, animated: true)
            return
            }
                        
            let time = selectedTimeForHabit
            let note = txtvNote.text ?? ""
            
            let frequency = FrequencyType.weekly
            let reminderOn = reminderSwitch.isOn
           
            
//            let savedData = ["name": name,
//                             "time" : time,
//                             "frequency": frequency,
//                             "note": note]
            
            let ctx = DataBaseHelper.sharedInstance.context
            let habit: Habits
            
            habit = Habits(context: ctx!)
            
            habit.id = UUID()
            habit.createdAt = Date.now
            habit.name = name
            habit.notes = note
            habit.time = time
            habit.frequencyData = frequency
            habit.isReminderOn = reminderOn
            
            if frequency == .weekly
            {
                habit.weeklyDays = Array(selectedWeekdays)
            }
            else {
                habit.weeklyDays = nil
            }


            if frequency == .monthly
            {
                habit.monthlyDates = Array(selectedMonthDates)
            }
            else
            {
                habit.monthlyDates = nil
            }
            
            if(isUpdated){
//                DataBaseHelper.sharedInstance.editData(object: savedData as! [String:String], index: selectedIndex)
//                navigationController?.popViewController(animated: true)
            }else{
                DataBaseHelper.sharedInstance.save(habit)
                navigationController?.popViewController(animated: true)
            }
            
            dataPassDelegate?.refreshPage()
        }
        
        @IBAction func onClickDailyBtn(_ sender: Any) {
            resetButtonColors()
            btnDaily.backgroundColor = .green
            frequecyContainerStack.isHidden = true
        }
        
        
        @IBAction func onClickMonthlyBtn(_ sender: Any) {
            resetButtonColors()
            btnMonthly.backgroundColor = .green
            frequecyContainerStack.isHidden = false
            weeklyView.isHidden = true
            montlyView.isHidden = false
        }
        @IBAction func onClickWeeklyBtn(_ sender: Any) {
            resetButtonColors()
            btnWeekly.backgroundColor = .green
            frequecyContainerStack.isHidden = false
            montlyView.isHidden = true
            weeklyView.isHidden = false
        }
        
        
        @IBAction func onClickSwitch(_ sender: Any) {
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
    
    extension AddHabitViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return weekDay.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! WeekDayCollectionViewCell
            cell.lblWeekDay.text = weekDay[indexPath.row]
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 10
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 70, height: 40)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = Utility.randomPastelColor()
                selectedWeekdays.insert(indexPath.item + 1)  // +1 because days are 1...7
                   print("Selected: \(selectedWeekdays)")
            }
        }
        func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.contentView.backgroundColor = .white
                selectedWeekdays.remove(indexPath.item + 1)
                    print("Selected: \(selectedWeekdays)")
            }
        }
    }
