//
//  DashBoardViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 14/08/25.
//

import UIKit
import DGCharts

class DashBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,DataPass ,CellCheckMarkDelegate{
    
   
    @IBOutlet weak var barChatView: BarChartView!
    
    

    @IBOutlet weak var userTableView: UITableView!
   
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    var habitList: [Habits] = []
    var filteredHabits: [Habits] = []
    var selectedDate: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarUI()
        barChatView.layer.cornerRadius = 10
        userImage.layer.cornerRadius = 20
        let nibcell = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        userTableView.register(nibcell, forCellReuseIdentifier: "DashBoardTableViewCell")
        userTableView.dataSource = self
        userTableView.delegate = self
       //  setupChart()
       // addCalender()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        fetchHabbits()
    }
    
    func setUpCalendarUI(){
        calendarView.layer.cornerRadius = 10
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.purple.cgColor
        calendarView.layer.masksToBounds = true
        calendarView.backgroundColor = UIColor.gray
        calendarView.scope = .week
        
       // calendarView.weekdayHeight = 40
        calendarView.rowHeight = 120

        calendarView.appearance.headerDateFormat = "MMMM yyyy"
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 16, weight: .medium)

        calendarView.appearance.weekdayTextColor = .blue
        calendarView.appearance.weekdayFont = UIFont.systemFont(ofSize: 14, weight: .medium)

        calendarView.appearance.todayColor = .systemBlue
        calendarView.appearance.selectionColor = .systemRed
        calendarView.appearance.titleDefaultColor = .black
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        calendarView.delegate = self
        calendarView.dataSource = self

    }
    
    func setupChart() {
        let dataPoints = TrackHabitHelpers.getCompletionCounts(forLastNDays: 7)
            
            let entries = dataPoints.enumerated().map { (index, item) in
                return BarChartDataEntry(x: Double(index), y: Double(item.count))
            }
            
            let dataSet = BarChartDataSet(entries: entries, label: "Habits Completed")
            dataSet.colors = ChartColorTemplates.pastel()
            
            let data = BarChartData(dataSet: dataSet)
          barChatView.data = data
        data.barWidth = 0.4

            
            // Customize
        barChatView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints.map {
                DateFormatter.shortWeekday.string(from: $0.date)
            })
        barChatView.xAxis.granularity = 1
        }
    
    func fetchHabbits(){
        selectedDate = Date() // Default date = today
        habitList = DataBaseHelper.sharedInstance.getHabitData()
        filterHabits(for: selectedDate)
       // userTableView.reloadData()
        
    }
    func refreshPage() {
        fetchHabbits()
    }
    
    func filterHabits(for date: Date) {
        print("\(date)")
        filteredHabits = habitList.filter { habit in
          //  guard let frequency = habit.frequencyData else { return false }
            
            switch habit.frequencyData {
            case .daily:
                return true
            case .weekly:
                if let days = habit.weeklyDays {
                    return days.contains(TrackHabitHelpers.weekdayMondayIsOne(date))
                }
                return false
//                let match = habit.weeklyDays?.contains(weekday(from: date)) ?? false
//                print("📅 Weekly \(habit.name ?? "") -> \(match)")
//                return match
            case .monthly:
                if let dates = habit.monthlyDates {
                    let targetDay = TrackHabitHelpers.dayOfMonth(date)
                               return dates.contains { stored in
                                   TrackHabitHelpers.dayOfMonth(stored) == targetDay
                               }
                           }
                           return false

            default:
                return false
            }
        }
        userTableView.reloadData()
    }

    func weekday(from date: Date) -> Int {
        // Sunday = 1, Monday = 2, ... Saturday = 7
        
        var systemWeekDay = Calendar.current.component(.weekday, from: date)
        let adjusted = (systemWeekDay + 5) % 7 + 1
        return adjusted
    }

    func day(from date: Date) -> Int {
        // 1...31 (day of the month)
        return Calendar.current.component(.day, from: date)
    }

    
    
    @IBAction func onClickPlusBtn(_ sender: Any) {
        let vc = AddHabitViewController()
        vc.dataPassDelegate = self
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func OnClickCheckMArk(index: Int) {
        let habit = filteredHabits[index]
        let log = DataBaseHelper.sharedInstance.getOrCreateHabitLog(habit: habit, on: selectedDate)

           log.isCompleted.toggle()
           DataBaseHelper.sharedInstance.save(habit)
           userTableView.reloadData() //reloadRows(at: index, with: .automatic)
//
//           do {
//               try DataBaseHelper.sharedInstance.save(habit)
//               tableView.reloadRows(at: [indexPath], with: .automatic)
//           } catch {
//               print("Save log failed: \(error)")
//           }
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredHabits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTableViewCell", for: indexPath) as! DashBoardTableViewCell
        let habit = filteredHabits[indexPath.row]

        cell.bindData(data: habit, index: indexPath.row)
        cell.onCheckMarkTapped = self
        if let log = DataBaseHelper.sharedInstance.fetchHabitLog(habit: habit, on: selectedDate), log.isCompleted {
            cell.btnCheckMark.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
           } else {
               cell.btnCheckMark.setImage(UIImage(systemName: "circle"), for: .normal)
           }
        
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddHabitViewController()
        vc.selectedHabitData = filteredHabits[indexPath.row]
        vc.isUpdated = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Remove from data source
            let habitToDelete = filteredHabits[indexPath.row]
                
                // Delete from Core Data
                DataBaseHelper.sharedInstance.deleteHabit(habit: habitToDelete)
                
                // Remove from both arrays
                if let indexInAll = habitList.firstIndex(where: { $0.id == habitToDelete.id }) {
                    habitList.remove(at: indexInAll)
                }
                filteredHabits.remove(at: indexPath.row)
            
            // Remove row from tableView with animation
            userTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

//    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        <#code#>
//    }

}
extension DashBoardViewController: FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
        selectedDate = date
        filterHabits(for: date)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        print("height \(bounds.height)")
        self.view.layoutIfNeeded()
    }
    
}
