//
//  Globals.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

//MARK: Heigh for rows
let heighForRow: CGFloat = 68

let secondsInDay: Double = 86400

//MARK: Massage Label generation

func generateMassageLabel() -> UILabel {
    let label = UILabel()
    label.textColor = grassGreen
    label.backgroundColor = UIColor.clear
    label.font = UIFont.systemFont(ofSize: 18)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
}

//MARK: Create UIImageView for background

func generateBackgroundImageView() -> UIImageView {
    guard let backgroundImage = backgroundImage else { return UIImageView() }
    let backgroundView = UIImageView(image: backgroundImage)
    return backgroundView
}
