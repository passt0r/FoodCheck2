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
    
    private var cashedDecorationView = [UICollectionViewLayoutAttributes]()
    
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
        position.size.height = 16
        
        for atribute in mutatingAtributes {
            atribute.zIndex = 1
            if atribute.frame.maxY > position.origin.y {
                position.origin.y = atribute.frame.maxY
                if rect.intersects(position) {
                    var atribute: UICollectionViewLayoutAttributes? = nil
                    for decorationView in cashedDecorationView {
                        if decorationView.frame == position {
                            atribute = decorationView
                        }
                    }
                    if let atribute = atribute {
                        mutatingAtributes.append(atribute)
                    } else {
                        guard let shelfAtribute = layoutAttributesForDecorationView(ofKind: DecorationViewKind.shelfView.rawValue, at: IndexPath(index: cashedDecorationView.count)) else {
                            continue
                        }
                        shelfAtribute.frame = position
                        cashedDecorationView.append(shelfAtribute)
                        mutatingAtributes.append(shelfAtribute)
                    }
                }
                
            }
        }

        return mutatingAtributes
    }
    
    override func prepare() {
        super.prepare()
        cashedDecorationView.removeAll()
        let topInset = collectionView?.contentInset.top
        //TODO: implement calculating for decorationView
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: super.collectionViewContentSize.width, height: super.collectionViewContentSize.height + 16)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
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
