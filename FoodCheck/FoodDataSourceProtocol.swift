//
//  FoodDataSourceProtocol.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 04.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import RealmSwift

protocol MutableFoodDataSource: class {
    //TODO: Use generics to implement protocol
    init() throws
    
    func findFoodBy(name: String) -> AddedUserFood?
    
    func findFoodBy(qr: String) -> AddedUserFood?
    
    //Add food to user food model
    func addFood(byName: String) -> Bool
    func addFood(byQR: String) -> Bool
    
    //Get food elements for Your Food screen
    func getFoodItemCount() -> Int
    func getFood(at indexPath: IndexPath) -> UserFood
    //Use for deleting UserFood item
    func delete(food: UserFood)
    
    //Uses for manual searching of food
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    func addUserCreatedFood(_ food: AddedUserFood)
    
    //Use for modifyUserCreatedFood
    func getFulInfo(about userFood: UserFoodInformation) -> AddedUserFood?
    
//    func modificateUserCreatedFood(_ food: AddedUserFood)
    
    //Delete all AddedUserFood
    func deleteAllUserInfo()
    
}

protocol ImmutableFoodDataSource: class {
    init() throws
    
    func getAllFoodTypes() -> [FoodType]
    
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    func findFoodBy(name: String) -> BaseFood?
    
    func findFoodBy(qr: String) -> BaseFood?
}

protocol UserFoodInformation: class {
    var name: String { get set }
    var foodType: String { get set }
    var iconName: String { get set }
    var shelfLife: TimeInterval { get set }
    var qrCode: String? { get set }
}
