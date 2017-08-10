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

//MARK: Food Types enum
enum FoodTypes: String {
    case fruit = "Fruit"
}
