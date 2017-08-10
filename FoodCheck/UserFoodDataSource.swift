//
//  UserFoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class UserFood: Object {
    
    dynamic var name = ""
    dynamic var iconName = "fruit"
    dynamic var endDate = Date()
}

class AddedUserFood: Object, UserFoodInformation {
    
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

class UserDataSource: MutableFoodDataSource {
    private let dataBase: Realm
    
    private var resultOfQueryingUserFood: Results<UserFood>!
    private var resultOfQueryingBaseFood: Results<AddedUserFood>!
    
    private var baseUserFoodDataSource: BaseUserFoodDataSource!
    
    required init() throws {
        dataBase = try Realm()
        
        resultOfQueryingUserFood = dataBase.objects(UserFood.self).sorted(byKeyPath: "endDate")
        resultOfQueryingBaseFood = dataBase.objects(AddedUserFood.self).sorted(byKeyPath: "name")
    }
    
    func getFood(byQR: String) -> UserFood? {
        return dataBase.objects(UserFood.self).first
    }
    
    func getFood(byName: String) -> UserFood {
        return UserFood()
    }
    
    func get(at indexPath: IndexPath) -> UserFood {
        return resultOfQueryingUserFood[indexPath.item]
    }
    
    func getFoodItemCount() -> Int {
        return resultOfQueryingUserFood.count
    }
    
    func add(food: AddedUserFood) {
        
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        let element = AddedUserFood()
        return [element]
    }
    
    func addUserCreatedFood(_ food: AddedUserFood) {
        
    }
    
    func delete(food: UserFood) {
        
    }
    
    func deleteAllFood(withAddedBase: Bool) {
        
    }
}
