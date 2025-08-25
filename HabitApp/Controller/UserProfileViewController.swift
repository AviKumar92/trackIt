//
//  UserProfileViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var datalist:[SidemenuDataModel] = []
    @IBOutlet weak var userProfileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        let nib = UINib(nibName: "UserProfileViewTableViewCell", bundle: nil)
        userProfileTableView.register(nib, forCellReuseIdentifier: "UserProfileCell")
        userProfileTableView.dataSource = self
        userProfileTableView.delegate = self
        
    }
    
    func loadData() {
        datalist.append(SidemenuDataModel(title: "UserProfile"))
        datalist.append(SidemenuDataModel(title: "Notification"))
        datalist.append(SidemenuDataModel(title: "Setting"))
        datalist.append(SidemenuDataModel(title: "Logout"))
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datalist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as! UserProfileViewTableViewCell
//        cell.lblName.text = datalist[indexPath.row].title
        cell.bindData(data: datalist[indexPath.row])
        return cell
    }


}

struct SidemenuDataModel {
    var title: String
}
