//
//  YourFoodFlowLayout.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class YourFoodFlowLayout: UICollectionViewFlowLayout {
    private enum DecorationViewKind: String {
        case shelfView = "ShelfView"
    }
    
    override init() {
        super.init()
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: DecorationViewKind.shelfView.rawValue)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: DecorationViewKind.shelfView.rawValue)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let atributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var mutatingAtributes = atributes
        //find max Y position of the cells
        var position = CGRect.zero
        position.size.width = rect.size.width
        position.size.height = 20
        var rowsYCoordinates = [CGFloat]()
        
        for atribute in mutatingAtributes {
            atribute.zIndex = 1
            if atribute.frame.maxY > position.origin.y {
                position.origin.y = atribute.frame.maxY
                rowsYCoordinates.append(atribute.frame.maxY)
            }
        }
        
        //if this view in rect, than create this view atribute and add it to the atributes array
        for rowYCoordinate in rowsYCoordinates {
            position.origin.y = rowYCoordinate
            let indexNumber = rowsYCoordinates.index(of: rowYCoordinate)!
            if rect.intersects(position) {
                let indexPath = IndexPath(row: indexNumber, section: 0)
                let shelfAtribute = layoutAttributesForDecorationView(ofKind: DecorationViewKind.shelfView.rawValue, at: indexPath)!
                shelfAtribute.frame = position
                shelfAtribute.zIndex = 0
                mutatingAtributes.append(shelfAtribute)
            }
        }
        
        return mutatingAtributes
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let atributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        
        return atributes
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case DecorationViewKind.shelfView.rawValue:
            return UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        default:
            print("Unexpected decoration layout element kind")
            return nil
        }
    }
}
