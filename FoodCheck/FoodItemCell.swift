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
    
    private func setBackgrounView() {
    let view = UIView(frame: self.bounds)
        view.backgroundColor = peachTint
        view.layer.cornerRadius = 5
        self.selectedBackgroundView = view
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgrounView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackgrounView()
    }
    
}
