//
//  AddFoodToFridgeDelegate.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation

protocol FoodSearchingController: class {
    var dataSource: MutableFoodDataSource! { get set }
    weak var delegate: AddFoodToFridgeDelegate? { get set }
    func performSearch(withInfo info: String)
}

protocol AddFoodToFridgeDelegate: class {
    func foodAddToFridge(_ source: FoodSearchingController, successfuly added: Bool)
}
