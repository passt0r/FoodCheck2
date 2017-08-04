//
//  MockFoodDataSource.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 04.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class MockFoodDataSource {
    private var food: [MockFood]
    
    init() {
        self.food = [MockFood]()
    }
    
    convenience init(food: MockFood) {
        self.init()
        self.food.append(food)
    }
    required init(foodArray: [MockFood]) {
        self.food = foodArray
    }
    
    func add(element: MockFood) {
        food.append(element)
    }
    func add(sequence: [MockFood]) {
        food.append(contentsOf: sequence)
    }
    func getFood() -> [MockFood] {
        return food
    }
    func getFood(at index: IndexPath) -> MockFood {
        return food[index.row]
    }
    func deleteFood(at index: IndexPath) {
        food.remove(at: index.row)
    }
    func deleteAllFood() {
        food.removeAll()
    }

    func foodCount() -> Int {
        return food.count
    }
}
