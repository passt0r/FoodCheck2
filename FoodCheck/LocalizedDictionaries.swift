//
//  LocalizedDictionaries.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation

//MARK: Food Types
//TODO: Implement better way for localized food type names
let localizedFoodTypesArray: [String: String] = [
    "Fruit": NSLocalizedString("Fruit", comment: "Food type description for fruit"),
    "Meet": NSLocalizedString("Meet", comment: "Food type description for meet"),
    "Fish": NSLocalizedString("Fish", comment: "Food type description for fish"),
    "Milk": NSLocalizedString("Milk", comment: "Food type description for milk"),
    "Bread": NSLocalizedString("Bread", comment: "Food type description for bread"),
    "Vegitables": NSLocalizedString("Vegitables", comment: "Food type description for vegitables"),
    "Sweets": NSLocalizedString("Sweets", comment: "Food type description for sweets"),
    "Canned Goods": NSLocalizedString("Canned Goods", comment: "Food type description for canned food"),
    "User Added": NSLocalizedString("User Added", comment: "Food type description for user added food"),
    "Without Type": NSLocalizedString("Without Type", comment: "Food type description for food without type")
]
