//
//  FoodDataSourceProtocol.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 04.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import RealmSwift

//This protocol uses for declarating base functionality of the user interacting data source
//It can be used in general data source and user manipulating data source
protocol MutableFoodDataSource: class {
    //TODO: Use generics to implement protocol
    init(with baseData: ImmutableFoodDataSource) throws
    
    //Add food to user food model
    func addFood(byName: String) -> Bool
    func addFood(byQR: String) -> Bool
    
    //Get food elements for Your Food screen
    func getFoodItemCount() -> Int
    func get(at indexPath: IndexPath) -> UserFood
    //Use for deleting UserFood item
    func delete(food: UserFood)
    
    //Uses for manual searching of food
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    func addUserCreatedFood(_ food: AddedUserFood)
    
    //Use for modifyUserCreatedFood
    func getFulInfo(about userFood: UserFoodInformation) -> AddedUserFood
    
    func modifyUserCreatedFood(_ food: AddedUserFood)
    
    //Delete all UserFood
    func deleteAllUserFood()
    
    //Delete all AddedUserFood
    func deleteAllUserAddedFood()
    
}

protocol ImmutableFoodDataSource: class {
    init() throws
    
    func getAllFoodTypes() -> [FoodType]
    
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    func findFoodBy(name: String) -> UserFood?
    
    func findFoodBy(qr: String) -> UserFood? 
}

protocol UserFoodInformation: class {
    var name: String { get set }
    var foodType: String { get set }
    var iconName: String { get set }
    var shelfLife: TimeInterval { get set }
}
