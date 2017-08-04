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
    
    public func configureCell(for foodItem: MockFood) {
        let foodIcon = UIImage(named: foodItem.imageName)
        let foodName = foodItem.name
        
        self.foodName.text = foodName
        
        if let foodIcon = foodIcon {
            self.foodIcon.image = foodIcon
        } else {
            self.foodIcon.image = UIImage(named: "fruit")!
        }
    }
    
}
