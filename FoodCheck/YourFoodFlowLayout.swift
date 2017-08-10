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
    
    private let shelfSize: CGFloat = 16
    
    private var cachedDecorationView = [UICollectionViewLayoutAttributes]()
    
    override init() {
        super.init()
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: DecorationViewKind.shelfView.rawValue)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.register(ShelfCollectionReusableView.self, forDecorationViewOfKind: DecorationViewKind.shelfView.rawValue)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //Tip: layoutAtributes with the same indexPath may can not be allowed for reusing
        guard let atributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var mutatingAtributes = atributes
        
        //find max Y position of the cells
        var position = CGRect.zero
        position.size.width = rect.size.width
        position.size.height = shelfSize
        
        for atribute in mutatingAtributes {
            atribute.zIndex = 1
            if atribute.frame.maxY > position.origin.y {
                position.origin.y = atribute.frame.maxY
                if rect.intersects(position) {
                    let shelf = prerareShelves(for: position)
                    mutatingAtributes.append(shelf)
                }
                
            }
        }

        return mutatingAtributes
    }
    
    func prerareShelves(for rect: CGRect) -> UICollectionViewLayoutAttributes {
        for cache in cachedDecorationView {
            if cache.frame == rect {
                return cache
            }
        }
        let indexForNewDecoration = Int(rect.origin.y/itemSize.height + shelfSize)
        let decoratorView = layoutAttributesForDecorationView(ofKind: DecorationViewKind.shelfView.rawValue, at: IndexPath(item: indexForNewDecoration, section: 0))!
        decoratorView.frame = rect
        cachedDecorationView.append(decoratorView)
        return decoratorView
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.size != newBounds.size
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        //delete all cached decoration views before new layout process
        cachedDecorationView.removeAll()
    }
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: super.collectionViewContentSize.width, height: super.collectionViewContentSize.height + shelfSize/1.5)
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
    
    override func finalLayoutAttributesForDisappearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let atribute = layoutAttributesForDecorationView(ofKind: elementKind, at: decorationIndexPath)
        guard let size = collectionView?.bounds.size else {
            return atribute
        }
        atribute?.center.x = size.width * 2
        return atribute
    }
}
