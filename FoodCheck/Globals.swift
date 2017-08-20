//
//  Globals.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import Crashlytics

//MARK: Appearance property
//MARK: Colors are global for posibility to use them over all app
let peachTint = UIColor(red: 240/255, green: 140/255, blue: 60/255, alpha: 1.0)
let grassGreen = UIColor(red: 70/255, green: 170/255, blue: 0/255, alpha: 1.0)

//MARK: Background image for screens, must use valid name
let backgroundImage = UIImage(named: "Fridge_background")

//MARK: Error handling

func record(error: NSError) {
    Crashlytics.sharedInstance().recordError(error)
}

let MyDataModelDidFailNotification = Notification.Name(rawValue: "MyDataModelDidFailNotification")

func fatalRealmError(_ error: Error) {
    print("***Fatal error with dataBase: \(error)")
    record(error: error as NSError)
    NotificationCenter.default.post(name: MyDataModelDidFailNotification, object: nil)
}

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

//MARK: Food Types

let foodTypesArray: [String] = [
    "Fruit",
    "Meet",
    "Fish",
    "Milk",
    "Bread",
    "Vegitables",
    "Sweets",
    "Canned Goods",
    "User Added",
    "Without Type"
]

let foodIconsArray: [String] = [
]

//enum FoodTypes: String {
//    case fruit = "Fruit"
//    case meet = "Meet"
//    case fish = "Fish"
//    case milk = "Milk"
//    case bread = "Bread"
//    case vegitables = "Vegitables"
//    case sweets = "Sweets"
//    case сanned_goods = "Canned Goods"
//    case userAdded = "User Added"
//    case without_type = "Without Type"
//}

//enum FoodIcons: String {
//    case meet = "beef"
//    case fish = "fish"
//    case milk = "milk"
//    case bread = "bread"
//    case vegitables = "vegitables"
//    case fruit = "fruit"
//    case sweets = "sweets"
//    case сanned_goods = "сanned_goods"
//    case cucumber = "cucumber"
//    case apple = "apple"
//    case baguette = "baguette"
//    case banana = "banana"
//    case bread_2 = "bread_2"
//    case broccoli = "broccoli"
//    case butter = "butter"
//    case cabbage = "cabbage"
//    case carrot = "carrot"
//    case cheese = "cheese"
//    case eggs = "eggs"
//    case grapes = "grapes"
//    case ham = "ham"
//    case ice_cream = "ice_cream"
//    case onion = "onion"
//    case orange = "orange"
//    case pear = "pear"
//    case piece_of_cake = "piece_of_cake"
//    case potatoes = "potatoes"
//    case roast_chicken = "roast_chicken"
//    case salami = "salami"
//    case salmon = "salmon"
//    case strawberry = "strawberry"
//    case sushi = "sushi"
//    case tomatoes = "tomatoes"
//    case tuna = "tuna"
//    case yogurt = "yogurt"
//}
