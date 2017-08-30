//
//  Colors.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

//MARK: Appearance property
//MARK: Colors are global for posibility to use them over all app
let peachTint = UIColor(red: 240/255, green: 120/255, blue: 30/255, alpha: 1.0)
let grassGreen = UIColor(red: 60/255, green: 155/255, blue: 10/255, alpha: 1.0)

func peachTint(withAlpha alpha: CGFloat) -> UIColor {
    return UIColor(red: 240/255, green: 120/255, blue: 30/255, alpha: alpha)
}

func grassGreen(withAlpha alpha: CGFloat) -> UIColor {
    return UIColor(red: 60/255, green: 155/255, blue: 10/255, alpha: alpha)
}
