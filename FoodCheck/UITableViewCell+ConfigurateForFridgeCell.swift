//
//  UITableViewCell+ConfigurateForFridgeCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 21.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func configurateForFridgeCell() {
        let backgroundView = UIView(frame: self.bounds)
        guard let backgroundImage = shelfImage else { return }
        backgroundView.setBackground(image: backgroundImage)
        self.backgroundView = backgroundView
    }
}
