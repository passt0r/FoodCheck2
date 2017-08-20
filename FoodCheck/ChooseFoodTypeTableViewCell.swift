//
//  ChooseFoodTypeTableViewCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class ChooseFoodTypeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurateForFridgeCell()
        accessoryView = UIImageView(image: nextArrow)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
