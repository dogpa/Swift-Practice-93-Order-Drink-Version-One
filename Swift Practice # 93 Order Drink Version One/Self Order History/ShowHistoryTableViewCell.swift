//
//  ShowHistoryTableViewCell.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/13.
//

import UIKit

class ShowHistoryTableViewCell: UITableViewCell {
    //第二頁歷史訂單內tableview的label
    @IBOutlet weak var showHistoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
