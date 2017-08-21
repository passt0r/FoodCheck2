//
//  AddIconTableViewCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 21.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class AddIconTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        configurateForFridgeCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
