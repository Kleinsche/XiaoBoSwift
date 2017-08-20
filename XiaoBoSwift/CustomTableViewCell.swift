//
//  CustomTableViewCell.swift
//  XiaoBoSwift
//
//  Created by 🍋 on 2017/4/15.
//  Copyright © 2017年 🍋. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var provinceLabel: UILabel!
    @IBOutlet var partLabel: UILabel!
    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var visitedImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
