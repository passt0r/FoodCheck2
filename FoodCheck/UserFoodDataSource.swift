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
    
    override static func primaryKey() -> String? {
        return "name"
    }
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

//TODO: Implement dataSource here

class UserDataSource: MutableFoodDataSource {
    private let baseWorkingError = NSError(domain: "UserDataSourceError", code: 1, userInfo: nil)
    
    private let dataBase: Realm
    
    private var resultOfQueryingUserFood: Results<UserFood>!
    
    private var baseUserFoodDataSource: ImmutableFoodDataSource!
    
    required init() throws {
        dataBase = try Realm()
        baseUserFoodDataSource = try BaseUserFoodDataSource()
        
        resultOfQueryingUserFood = dataBase.objects(UserFood.self).sorted(byKeyPath: "endDate")
        
    }
    
    private func createUserFood(from foodInfo: UserFoodInformation) -> UserFood {
        let userFood = UserFood()
        userFood.name = foodInfo.name
        userFood.iconName = foodInfo.iconName
        userFood.endDate = Date(timeIntervalSinceNow: foodInfo.shelfLife)
        
        return userFood
    }
    
    private func addToFridge(food: UserFoodInformation) {
        let foodToFridge = createUserFood(from: food)
        try! dataBase.write {
            dataBase.add(foodToFridge)
        }
    }
    
    func getAllFoodTypes() -> [FoodType] {
        return baseUserFoodDataSource.getAllFoodTypes()
    }
    
    // If food do not find in bindedBase, than food will be surely find at this base
    func findFoodBy(name: String) -> AddedUserFood? {
            let predicate = NSPredicate(format: "name == %@", name)
            let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate).sorted(byKeyPath: "name")
            guard let findedFood = resultOfSearching.first else { return nil }
            return findedFood
    }
    
    func findFoodBy(qr: String) -> AddedUserFood? {
        let predicate = NSPredicate(format: "qrCode == %@", qr)
        let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate).sorted(byKeyPath: "name")
        guard let findedFood = resultOfSearching.first else { return nil }
        return findedFood
    }
    
    //MARK: Can be possible add food without correct name? I think not, that's why it must throw exeption
    func addFood(byName name: String) -> Bool {
        if let findedFood = baseUserFoodDataSource.findFoodBy(name: name) {
            addToFridge(food: findedFood)
            return true
        } else if let findedFood = findFoodBy(name: name) {
            addToFridge(food: findedFood)
            return true
        }
        
        fatalRealmError(baseWorkingError)
        
        return false
    }
    
    func addFood(byQR code: String) -> Bool {
        if let findedFood = baseUserFoodDataSource.findFoodBy(qr: code) {
            addToFridge(food: findedFood)
            return true
        } else if let findedFood = findFoodBy(qr: code){
            addToFridge(food: findedFood)
            return true
        }
        
        return false
    }
    
    func getFoodItemCount() -> Int {
        return resultOfQueryingUserFood.count
    }
    
    func getFood(at indexPath: IndexPath) -> UserFood {
        return resultOfQueryingUserFood[indexPath.item]
    }
    
    func delete(food: UserFood) {
        try! dataBase.write {
            dataBase.delete(food)
        }
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        let element = AddedUserFood()
        return [element]
    }
    
    func addUserCreatedFood(_ food: AddedUserFood) {
        try! dataBase.write {
            dataBase.add(food, update: true)
        }
    }
    
    func deleteUserCreatedFood(_ food: AddedUserFood) {
        try! dataBase.write {
            dataBase.delete(food)
        }
    }
    
    func getFulInfo(about userFood: UserFoodInformation) -> AddedUserFood? {
        let predicate = NSPredicate(format: "foodType == %@ AND name == %@", userFood.foodType, userFood.name)
        let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate)
        guard let findFood = resultOfSearching.first else {
            return nil 
        }
        return findFood
    }
    
    //Delete all AddedUserFood
    func deleteAllUserInfo() {
        try! dataBase.write {
            dataBase.deleteAll()
        }
    }
}
