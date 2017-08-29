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
    
    var freshStage: freshStages = .Normal {
        didSet {
            setLayerForFreshStage()
        }
    }
    
    enum freshStages {
        case Normal
        case SoonEnd
        case End
    }
    
    private func setBackgrounView() {
    let view = UIView(frame: self.bounds)
        view.backgroundColor = peachTint
        view.layer.cornerRadius = 5
        self.selectedBackgroundView = view
        
    }
    
    private func setLayerForFreshStage() {
        let layer = self.layer
        layer.borderWidth = 3
        layer.cornerRadius = 5
        switch freshStage {
        case .Normal:
            layer.borderColor = UIColor.clear.cgColor
        case .SoonEnd:
            layer.borderColor = peachTint.cgColor
        case .End:
            layer.borderColor = UIColor.red.cgColor
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBackgrounView()
        setLayerForFreshStage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setBackgrounView()
    }
    
}
