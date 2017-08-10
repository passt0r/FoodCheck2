//
//  Globals.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

//MARK: Appearance property
//MARK: Colors are global for posibility to use them over all app
let peachTint = UIColor(red: 240/255, green: 140/255, blue: 60/255, alpha: 1.0)

//MARK: Error handling
let MyDataModelDidFailNotification = Notification.Name(rawValue: "MyDataModelDidFailNotification")

func fatalRealmError(_ error: Error) {
    print("***Fatal error: \(error)")
    NotificationCenter.default.post(name: MyDataModelDidFailNotification, object: nil)
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
