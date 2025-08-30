//
//  DashBoardTableViewCell.swift
//  HabitApp
//
//  Created by Avinash kumar on 14/08/25.
//

import UIKit

class DashBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var profile_Image: UIImageView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var btnCheckMark: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func bindData(data: Habits) {
      //  lblTime.text = data.time
        lblOne.text = data.name
        lblTwo.text = data.frequency
    }
    
    @IBAction func onClickCheckMark(_ sender: Any) {
    }
}
