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
    
    private var baseUserFoodDataSource: ImmutableFoodDataSource!
    
    required init(with baseData: ImmutableFoodDataSource) throws {
        dataBase = try Realm()
        
        resultOfQueryingUserFood = dataBase.objects(UserFood.self).sorted(byKeyPath: "endDate")
        resultOfQueryingBaseFood = dataBase.objects(AddedUserFood.self).sorted(byKeyPath: "name")
        baseUserFoodDataSource = baseData
    }
    
    func addFood(byName: String) -> Bool {
        return false
    }
    
    func addFood(byQR: String) -> Bool {
        return false
    }
    
    func getFoodItemCount() -> Int {
        return resultOfQueryingUserFood.count
    }
    
    func get(at indexPath: IndexPath) -> UserFood {
        return resultOfQueryingUserFood[indexPath.item]
    }
    
    func delete(food: UserFood) {
        
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        let element = AddedUserFood()
        return [element]
    }
    
    func addUserCreatedFood(_ food: AddedUserFood) {
        
    }
    
    func getFulInfo(about userFood: UserFoodInformation) -> AddedUserFood {
        return AddedUserFood()
    }
    
    func modifyUserCreatedFood(_ food: AddedUserFood) {
        
    }
    
    func deleteAllUserFood() {
        
    }
    //Delete all AddedUserFood
    func deleteAllUserAddedFood() {
        
    }
}
