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
    
    ///Return array that consist all Food Types with their info
    func getAllFoodTypes() -> [FoodType]
    
    ///Return optional AddedUserFood if find it by name, nil if not
    func findFoodBy(name: String) -> AddedUserFood?
    
    ///Return optional AddedUserFood if find it by code, nil if not
    func findFoodBy(qr: String) -> AddedUserFood?
    
    ///Add food to user food model by name and return bool value of result of operation
    func addFood(byName: String) -> Bool
    
    ///Add food to user food model by code and return bool value of result of operation
    func addFood(byQR: String) -> Bool
    
    ///Get count of food elements at your data base that was added
    func getFoodItemCount() -> Int
    
    ///Get UserFood element from data model with coresponding index path
    func getFood(at indexPath: IndexPath) -> UserFood
    
    ///Return array of user food from your data base that ends it's shelf life at corresponding date
    func getFood(with endDate: Date) -> [UserFood]
    
    ///Return array of user food from your data base that ends it's shelf life at corresponding date gap
    func getFood(fromDate: Date, toDate: Date) -> [UserFood]
    
    ///Use for deleting UserFood item
    func delete(food: UserFood)
    
    ///Uses for manual searching of foodType that correspond to food type name
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    ///Uses for adding new AddedUserFood item to data base
    func addUserCreatedFood(_ food: AddedUserFood)
    
    ///Uses for modification of AddedUserFood from data base with new info from item that correspond to UserFoodInformation
    func modifyUserCreatedFood(_ food: AddedUserFood, withInfo info: UserFoodInformation)
    
    ///Uses for deleting AddedUserFood item
    func deleteUserCreatedFood(_ food: AddedUserFood)
    
    ///Use for getting AddedUserFood item from item that coresponds UserFoodInformation protocol
    func getFulInfo(about userFood: UserFoodInformation) -> AddedUserFood?
    
    ///Use for deleting all user info
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
