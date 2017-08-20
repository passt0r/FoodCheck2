//
//  AddFoodTableViewCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class AddFoodTableViewCell: UITableViewCell {

    @IBOutlet weak var addFoodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurateForFridgeCell()
        addFoodButton.backgroundColor = grassGreen
        addFoodButton.tintColor = peachTint
        addFoodButton.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
