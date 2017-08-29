//
//  UIView+bounce.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 23.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
