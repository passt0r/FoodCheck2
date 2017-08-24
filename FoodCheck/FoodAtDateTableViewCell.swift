//
//  FoodAtDateTableViewCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 24.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class FoodAtDateTableViewCell: UITableViewCell {
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configurateForFridgeCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
