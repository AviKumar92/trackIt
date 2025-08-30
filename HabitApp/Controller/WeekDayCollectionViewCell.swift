//
//  WeekDayCollectionViewCell.swift
//  HabitApp
//
//  Created by Avinash kumar on 28/08/25.
//

import UIKit

class WeekDayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblWeekDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
    }

}
