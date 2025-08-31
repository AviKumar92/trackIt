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
    
    var onCheckMarkTapped: CellCheckMarkDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    func bindData(data: Habits, index: Int) {
      //  lblTime.text = data.time
        lblOne.text = data.name
        lblTwo.text = data.frequency
        btnCheckMark.tag = index
        
       
            }
    
    @IBAction func onClickCheckMark(_ sender: Any) {
        onCheckMarkTapped?.OnClickCheckMArk(index:  btnCheckMark.tag)
    }
}
