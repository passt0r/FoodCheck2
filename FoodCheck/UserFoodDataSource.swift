//
//  UserFoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 09.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift
import Crashlytics

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
        do {
            try dataBase.write {
                dataBase.add(foodToFridge)
            }
        } catch let error as NSError {
            record(error: error)
        }
    }
    
    func getAllFoodTypes() -> [FoodType] {
        return baseUserFoodDataSource.getAllFoodTypes()
    }
    
    func findFoodBy(name: String) -> AddedUserFood? {
            let predicate = NSPredicate(format: "name == %@", name)
            let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate).sorted(byKeyPath: "name")
            guard let findedFood = resultOfSearching.last else {
                return nil }
            return findedFood
    }
    
    func findFoodBy(qr: String) -> AddedUserFood? {
        let predicate = NSPredicate(format: "qrCode == %@", qr)
        let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate).sorted(byKeyPath: "name")
        guard let findedFood = resultOfSearching.last else { return nil }
        return findedFood
    }
    
    //MARK: Can be possible add food without correct name? I think not, that's why it must throw exeption
    func addFood(byName name: String) -> Bool {
        if let findedFood = findFoodBy(name: name) {
            addToFridge(food: findedFood)
            return true
        } else if let findedFood = baseUserFoodDataSource.findFoodBy(name: name) {
            addToFridge(food: findedFood)
            return true
        }
        
        
        
        return false
    }
    
    func addFood(byQR code: String) -> Bool {
        if let findedFood = findFoodBy(qr: code) {
            addToFridge(food: findedFood)
            return true
        } else if let findedFood = baseUserFoodDataSource.findFoodBy(qr: code){
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
    
    func getFood(with endDate: Date) -> [UserFood] {
        let beginOfDay = Calendar.current.startOfDay(for: endDate)
        let endOfDay: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: beginOfDay)!
        }()
        let predicate = NSPredicate(format: "endDate BETWEEN %@", [beginOfDay, endOfDay])
        let resultOfQuerying = dataBase.objects(UserFood.self).filter(predicate)
        var resultArray = [UserFood]()
        for result in resultOfQuerying {
            resultArray.append(result)
        }
        return resultArray
    }
    
    func getFood(fromDate: Date, toDate: Date) -> [UserFood] {
        let beginDate = Calendar.current.startOfDay(for: fromDate)
        let endDate = Calendar.current.startOfDay(for: toDate)
        
        let predicate = NSPredicate(format: "endDate BETWEEN %@", [beginDate, endDate])
        let resultOfQuerying = dataBase.objects(UserFood.self).filter(predicate)
        var resultArray = [UserFood]()
        for result in resultOfQuerying {
            resultArray.append(result)
        }
        return resultArray
    }
    
    func delete(food: UserFood) {
        do {
            try dataBase.write {
                dataBase.delete(food)
            }
        } catch let error as NSError {
            record(error: error)
        }
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        var findedFood = [UserFoodInformation]()
        findedFood.append(contentsOf: baseUserFoodDataSource.getAllFood(by: type))
        let predicate = NSPredicate(format: "foodType == %@", type)
        let resultOfSearching = dataBase.objects(AddedUserFood.self).filter(predicate).sorted(byKeyPath: "name")
        for searchedFood in resultOfSearching {
            findedFood.append(searchedFood)
        }
        return findedFood
    }
    
    //MARK: food.name is a primary key that can not be modifiing, if you want to modify food name, you must first delete this food element and than re-create it
    func addUserCreatedFood(_ food: AddedUserFood) {
        do {
            try dataBase.write {
                dataBase.add(food, update: true)
            }
        } catch let error as NSError {
            record(error: error)
        }
    }
    
    func deleteUserCreatedFood(_ food: AddedUserFood) {
        do {
            try dataBase.write {
                dataBase.delete(food)
            }
        } catch let error as NSError {
            record(error: error)
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
    
    //AddedUserFood use primaryKey, and when you want to modify user name, than you must use it
    func modifyUserCreatedFood(_ food: AddedUserFood, withInfo info: UserFoodInformation) {
        if info.name == food.name {
            addUserCreatedFood(info as! AddedUserFood)
        } else {
           deleteUserCreatedFood(food)
            addUserCreatedFood(info as! AddedUserFood)
        }
    }
    
    //Delete all AddedUserFood
    func deleteAllUserInfo() {
        do {
            try dataBase.write {
                dataBase.deleteAll()
            }
        } catch let error as NSError {
            record(error: error)
        }
    }
}
