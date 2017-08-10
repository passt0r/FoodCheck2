//
//  FoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 10.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class FoodDataSource {
    private let userFoodDataSource: MutableFoodDataSource
    private let baseFoodDataSource: ImmutableFoodDataSource
    
    required init() throws {
        baseFoodDataSource = try BaseUserFoodDataSource()
        userFoodDataSource = try UserDataSource(with: baseFoodDataSource)
        
    }
    
    //Use for create data source for testing, initiate with mock objects
    init(withGenerateTestData: Bool) throws {
        //TODO: initiate userFoodDataSource with mock object
        baseFoodDataSource = try BaseUserFoodDataSource()
        userFoodDataSource = try UserDataSource(with: baseFoodDataSource)
    }
    
    func addFood(byName: String) -> Bool {
        return false
    }
    
    func addFood(byQR: String) -> Bool {
        return false
    }
    
    func getFoodItemCount() -> Int {
        return 0
    }
    
    func get(at indexPath: IndexPath) -> UserFood {
        return UserFood()
    }
    
    func getAllFood(by type: String) -> [UserFoodInformation] {
        let array = [UserFoodInformation]()
        return array
    }
    
    func delete(food: UserFood) {
        
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
