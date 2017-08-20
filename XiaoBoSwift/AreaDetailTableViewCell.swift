//
//  AreaDetailTableViewCell.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/4/18.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class AreaDetailTableViewCell: UITableViewCell {
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
