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
        //FIXME: Tip: layoutAtributes with the same indexPath may can not be allowed for reusing
        guard let atributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var mutatingAtributes = atributes
        
        var findedDecorations: [UICollectionViewLayoutAttributes] = []
        for cache in cachedDecorationView {
            if rect.intersects(cache.frame) {
                findedDecorations.append(cache)
            }
        }
        if !findedDecorations.isEmpty {
            mutatingAtributes.append(contentsOf: findedDecorations)
            return mutatingAtributes
        }
        //find max Y position of the cells
        var position = CGRect.zero
        position.size.width = rect.size.width
        position.size.height = 16
        
        for atribute in mutatingAtributes {
            atribute.zIndex = 1
            if atribute.frame.maxY > position.origin.y {
                position.origin.y = atribute.frame.maxY
                let indexForNewDecoration = Int(position.origin.y/itemSize.height + 16)
                let decoratorView = layoutAttributesForDecorationView(ofKind: DecorationViewKind.shelfView.rawValue, at: IndexPath(item: indexForNewDecoration, section: 0))!
                decoratorView.frame = position
                cachedDecorationView.append(decoratorView)
                if rect.intersects(position) {
                    mutatingAtributes.append(decoratorView)
                }
                
            }
        }

        return mutatingAtributes
    }
    
    func prerareShelves(for atributes: [UICollectionViewLayoutAttributes]) {
        
    }
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        //delete all cached decoration views before new layout process
        cachedDecorationView.removeAll()
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
