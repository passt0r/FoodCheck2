//
//  UIView+ResizeForBackground.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 19.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

extension UIImage {
    func setBackground(for view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        self.draw(in: view.bounds)
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        view.backgroundColor = UIColor(patternImage: resizedImage)
    }
}

extension UIView {
    func setBackground(image: UIImage) {
        UIGraphicsBeginImageContext(self.frame.size)
        image.draw(in: self.bounds)
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.backgroundColor = UIColor(patternImage: resizedImage)
    }
}
