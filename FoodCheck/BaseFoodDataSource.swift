//
//  BaseFoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class BaseFood: Object, UserFoodInformation {
    
    dynamic var name = ""
    dynamic var foodType = ""
    dynamic var iconName = "fruit"
    dynamic var shelfLife = TimeInterval()
    dynamic var qrCode: String? = nil
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

//TODO: Implement dataSource here

class BaseUserFoodDataSource {
    private var dataBase: Realm!
    
    init() throws {
        
        dataBase = try Realm()
    }
    
    func findFoodBy(name: String) -> UserFood? {
        return nil
    }
    
    func findFoodBy(qr: String) -> UserFood? {
        return nil
    }
    
}
