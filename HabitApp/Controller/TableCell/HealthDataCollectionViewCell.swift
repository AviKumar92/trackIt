//
//  HealthDataCollectionViewCell.swift
//  HabitApp
//
//  Created by Avinash kumar on 16/08/25.
//

import UIKit

class HealthDataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var stepImage: UIImageView!
    @IBOutlet weak var lblTarget: UILabel!
    @IBOutlet weak var lblStepCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
    }

}
