//
//  AddNewFoodDelegate.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 21.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation

protocol MutatingUserAddedFoodController: class {
    weak var delegate: AddNewFoodDelegate! {get set}
    func addNewUserFood()
    func modifyUserAddedFood()
}

protocol AddNewFoodDelegate: class {
    func addOrChangeFood(_ source: MutatingUserAddedFoodController, successfully added: Bool)
}
