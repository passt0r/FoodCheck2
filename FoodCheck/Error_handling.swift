//
//  Error_handling.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import Crashlytics

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
