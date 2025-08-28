//
//  DashBoardViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 14/08/25.
//

import UIKit

class DashBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DataPass {
   
    
    

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var lblNotification: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var calendarView: FSCalendar!
    var habitList: [Habitdata] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.layer.cornerRadius = 10
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.purple.cgColor
        calendarView.layer.masksToBounds = true
        calendarView.scope = .week
        
        calendarView.appearance.headerDateFormat = "MMMM yyyy"
        calendarView.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 16)
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0   // hide faded months

        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .medium)
        calendarView.weekdayHeight = 30

        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        calendarView.appearance.todayColor = .systemRed
        calendarView.appearance.selectionColor = .systemBlue
        calendarView.appearance.borderRadius = 1.0             // ensures circle uses full cell


        
        
        lblNotification.layer.cornerRadius = 10
        userImage.layer.cornerRadius = 20
        let nibcell = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        userTableView.register(nibcell, forCellReuseIdentifier: "DashBoardTableViewCell")
        userTableView.dataSource = self
        userTableView.delegate = self
       // addCalender()
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchHabbits()
    }
    
    func fetchHabbits(){
        //DataBaseHelper.sharedInstance.getHabitData()
        habitList = DataBaseHelper.sharedInstance.getHabitData()
        userTableView.reloadData()
        
    }
    func refreshPage() {
        fetchHabbits()
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
     
        calendarView.frame.size.height = bounds.height
           self.view.layoutIfNeeded()
    }

    
    @IBAction func onClickPlusBtn(_ sender: Any) {
        var vc = AddHabitViewController()
        vc.dataPassDelegate = self
        present(vc, animated: true)
        
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTableViewCell", for: indexPath) as! DashBoardTableViewCell
        cell.bindData(data: habitList[indexPath.row])
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddHabitViewController()
        vc.selectedHabitData = habitList[indexPath.row]
        vc.isUpdated = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Remove from data source
            var updatedList = DataBaseHelper.sharedInstance.deleteData(index: indexPath.row)
            habitList.remove(at: indexPath.row)
            
            // Remove row from tableView with animation
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        <#code#>
//    }

}
extension DashBoardViewController: FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
        
    }
}
