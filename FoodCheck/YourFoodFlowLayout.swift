//
//  YourFoodFlowLayout.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class YourFoodFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: "ShelfView")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: "ShelfView")
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let atributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        
        return atributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }
}
