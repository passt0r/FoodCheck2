//
//  FoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 10.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation
import RealmSwift

class FoodDataSource: MutableFoodDataSource {
    private let userFoodDataSource: UserDataSource
    private let baseFoodDataSource: BaseUserFoodDataSource
    
    required init() throws {
        userFoodDataSource = try UserDataSource()
        baseFoodDataSource = try BaseUserFoodDataSource()
    }
    
    func getFood(byName: String) -> UserFood {
        return UserFood()
    }
    
    func getFood(byQR: String) -> UserFood? {
        return nil
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
}
