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

class FoodType: Object {
    dynamic var typeName = ""
    dynamic var typeIcon = ""
}

//TODO: Implement dataSource here

class BaseUserFoodDataSource: ImmutableFoodDataSource {
    private var dataBase: Realm!
    
    required init() throws {
        let baseURL = Bundle.main.url(forResource: "bindedBaseFood", withExtension: "realm")
        let config = Realm.Configuration(fileURL: baseURL, readOnly: true)
        dataBase = try Realm(configuration: config)
        
    }
    //Use only if need to generate sample data
    private func generateSample() {
        let testFoodType = FoodType()
        testFoodType.typeName = "Test"
        testFoodType.typeIcon = "fruit"
        
        let testBaseFood = BaseFood()
        testBaseFood.name = "TestFood"
        testBaseFood.foodType = "Test"
        testBaseFood.shelfLife = 10
        testBaseFood.qrCode = ""
        
        let testBaseFood2 = BaseFood()
        testBaseFood2.name = "TestFood 2"
        testBaseFood2.foodType = "Test"
        testBaseFood2.shelfLife = 10

        try! dataBase.write {
            dataBase.add(testFoodType)
            dataBase.add(testBaseFood)
            dataBase.add(testBaseFood2)
        }
    }
    
    func getAllFoodTypes() -> [FoodType] {
        
        return [FoodType()]
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        return [BaseFood()]
    }
    
    func findFoodBy(name: String) -> UserFood? {
        return nil
    }
    
    func findFoodBy(qr: String) -> UserFood? {
        return nil
    }
    
}
