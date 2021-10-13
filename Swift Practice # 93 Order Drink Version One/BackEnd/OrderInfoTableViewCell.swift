//
//  OrderInfoTableViewCell.swift
//  Swift Practice # 93 Order Drink Version One
//
//  Created by Dogpa's MBAir M1 on 2021/10/12.
//

import UIKit

class OrderInfoTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var timeLabel: UILabel!          //訂單時間
    
    @IBOutlet weak var drinkNameLabel: UILabel!     //飲料名稱
    
    @IBOutlet weak var sizeLabel: UILabel!          //容量
    
    @IBOutlet weak var drinkCountLabel: UILabel!    //數量
    
    @IBOutlet weak var sugarLabel: UILabel!         //甜度
    
    @IBOutlet weak var tempLabel: UILabel!          //溫度
    
    @IBOutlet weak var priceLabel: UILabel!         //總價
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
