//
//  ShelfCollectionReusableView.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class ShelfCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addBackgroundImageView(with: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addBackgroundImageView(with: self.bounds)
    }
    
    private func addBackgroundImageView(with frame: CGRect) {
        guard let shelfImage = UIImage(named: "Shelf") else { return }
        let shelfImageView = UIImageView(image: shelfImage)
        shelfImageView.frame = frame
        self.addSubview(shelfImageView)
    }
    
}
