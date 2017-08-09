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
        //backgroundColor = UIColor.white
        let frameBounds = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        addBackgroundImageView(with: frameBounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addBackgroundImageView(with: self.bounds)
    }
    
    private func addBackgroundImageView(with frame: CGRect) {
        guard let shelfImage = UIImage(named: "Shelf") else { return }
        let shelfImageView = UIImageView(image: shelfImage)
        shelfImageView.contentMode = .scaleToFill
        shelfImageView.frame = frame
        shelfImageView.clipsToBounds = true
        self.addSubview(shelfImageView)
    }
    
}
