//
//  FoodItemCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class FoodItemCell: UICollectionViewCell {
    @IBOutlet weak var foodIcon: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    
    public func configureCell() {
        let foodIcon = UIImage()
        let foodName = String()
        
        self.foodIcon.image = foodIcon
        self.foodName.text = foodName
    }
    
}
