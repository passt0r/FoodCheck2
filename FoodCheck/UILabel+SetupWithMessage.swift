//
//  UILabel+SetupWithMessage.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 19.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

extension UILabel {
    func setupMessage(with message: String) {
        self.text = message
        self.centerXAnchor.constraint(equalTo: self.superview!.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: self.superview!.centerYAnchor).isActive = true
        self.widthAnchor.constraint(equalTo: self.superview!.widthAnchor, multiplier: 0.6).isActive = true
        self.heightAnchor.constraint(lessThanOrEqualTo: self.superview!.heightAnchor, multiplier: 0.3).isActive = true
    }
}
