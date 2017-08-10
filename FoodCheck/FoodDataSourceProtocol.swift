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
    init() throws
    
    func getFood(byName: String) -> UserFood
    func getFood(byQR: String) -> UserFood?
    
    func getFoodItemCount() -> Int
    func get(at indexPath: IndexPath) -> UserFood
    
    func getAllFood(by type: String) -> [UserFoodInformation]
    
    func delete(food: UserFood)
    
}

protocol UserFoodInformation: class {
    var name: String { get set }
    var foodType: String { get set }
    var iconName: String { get set }
    var shelfLife: TimeInterval { get set }
    var qrCode: String? { get set }
}
