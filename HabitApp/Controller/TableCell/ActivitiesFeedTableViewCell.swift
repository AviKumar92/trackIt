//
//  ActivitiesFeedTableViewCell.swift
//  HabitApp
//
//  Created by Avinash kumar on 22/08/25.
//

import UIKit

class ActivitiesFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var mapImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with activity: Activity) {
        mapImage.image = activity.snapshot
        distanceLbl.text = String(format: "%.2f km", activity.distanceMeters / 1000)
           let duration = activity.endDate.timeIntervalSince(activity.startDate)
        timeLbl.text = formatDuration(duration)
       }

       private func formatDuration(_ interval: TimeInterval) -> String {
           let minutes = Int(interval) / 60
           let seconds = Int(interval) % 60
           return String(format: "%02d:%02d", minutes, seconds)
       }
    
}
