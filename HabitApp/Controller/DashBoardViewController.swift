//
//  DashBoardViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 14/08/25.
//

import UIKit

class DashBoardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var lblNotification: UIView!
    @IBOutlet weak var lblDate: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      lblDate.layer.cornerRadius = 10
        lblNotification.layer.cornerRadius = 10
        userImage.layer.cornerRadius = 20
        let nibcell = UINib(nibName: "DashBoardTableViewCell", bundle: nil)
        userTableView.register(nibcell, forCellReuseIdentifier: "DashBoardTableViewCell")
        userTableView.dataSource = self
        userTableView.delegate = self
        addCalender()
        
       
    }
    
    @IBAction func onClickPlusBtn(_ sender: Any) {
        present(AddHabitViewController(), animated: true)
    }
    
    func addCalender() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 40, height: 110))
//        calendar.dataSource = self
//        calendar.delegate = self
        lblDate.addSubview(calendar)
       // self.calendar = calendar
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTableViewCell", for: indexPath) as! DashBoardTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
