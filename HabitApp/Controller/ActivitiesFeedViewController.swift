//
//  ActivitiesFeedViewController.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//

import UIKit

class ActivitiesFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var activities: [Activity] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Activity Feed"
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        let nibcell = UINib(nibName: "ActivitiesFeedTableViewCell", bundle: nil)
        tableView.register(nibcell, forCellReuseIdentifier: "ActivitiesFeedTableViewCell")
        
        // Record button
                navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: "Record",
                    style: .done,
                    target: self,
                    action: #selector(recordTapped)
                )
        // Load data & observe changes
                ActivityStore.shared.load { [weak self] items in
                    self?.activities = items
                    self?.tableView.reloadData()
                }
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(reloadData),
                                                       name: ActivityStore.didChange,
                                                       object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let top = UIColor(red: 158/255, green: 235/255, blue: 199/255, alpha: 1)   // #9EEBC7
                let bottom = UIColor(red: 255/255, green: 241/255, blue: 166/255, alpha: 1) // #FFF1A6
                view.applyGradient(colors: [top, bottom])
    }
    @objc private func reloadData() {
            ActivityStore.shared.load { [weak self] items in
                self?.activities = items
                self?.tableView.reloadData()
            }
        }

        @objc private func recordTapped() {
            // Assuming you have ActivityTrackerViewController in storyboard
            // with Storyboard ID = "ActivityTrackerViewController"
            let vc = ActivityTrackerViewController()

            // Provide a completion so tracker can return the saved activity
            vc.onFinished = { [weak self] activity in
                ActivityStore.shared.add(activity)
                self?.navigationController?.popViewController(animated: true)
            }

            navigationController?.pushViewController(vc, animated: true)
        }
}
extension ActivitiesFeedViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        activities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let a = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivitiesFeedTableViewCell", for: indexPath) as! ActivitiesFeedTableViewCell
        cell.configure(with: a)
//        cell.distanceLbl.text = "\(a.distanceKmString) • \(a.durationString)"
//        cell.timeLbl.text = a.startDateString
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
