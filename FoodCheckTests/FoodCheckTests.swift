//
//  FoodCheckTests.swift
//  FoodCheckTests
//
//  Created by Dmytro Pasinchuk on 02.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import XCTest

@testable import FoodCheck
//TODO: Rewrite this for testing general data source and user mutable data source
let validQRCodeInfo = "Sample milk for FoodCheck"
let validFoodName = "Milk"
let validIconName = "fruit"
let userAddedFoodType = "User Added"

func generateSampleFood() -> UserFood {
    let testExample = UserFood()
    testExample.name = "Test"
    testExample.iconName = validIconName
    testExample.endDate = Date(timeIntervalSinceNow: 10)
    
    return testExample
}

func generateSampleAddedUserFood() -> AddedUserFood {
    let testExample = AddedUserFood()
    testExample.name = validFoodName
    testExample.foodType = userAddedFoodType
    testExample.iconName = validIconName
    testExample.shelfLife = 1
    testExample.qrCode = validQRCodeInfo
    
    return testExample
}

class UserDataSourceTests: XCTestCase {
    
    var testableDataSource: UserDataSource!
    
    
    override func setUp() {
        super.setUp()
        do {
            testableDataSource = try UserDataSource()
        } catch let error as NSError {
            fatalError("***Error: \(error)")
        }
        
    }
    
    override func tearDown() {
        testableDataSource.deleteAllUserInfo()
        testableDataSource = nil
        super.tearDown()
    }
    
    func testFindFoodByName() {
        let foodToAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodToAdd)
        
        guard let result = testableDataSource.findFoodBy(name: validFoodName) else {
            XCTFail("Error when find food, food not found")
            return
        }
        
        XCTAssertEqual([foodToAdd.name, foodToAdd.foodType, foodToAdd.iconName], [result.name, result.foodType, result.iconName], "Problems with searching food by name")
    }
    
    func testFindFoodByQR() {
        let foodToAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodToAdd)
        
        guard let result = testableDataSource.findFoodBy(qr: validQRCodeInfo) else {
            XCTFail("Error when find food, food not found")
            return
        }
        
        XCTAssertEqual([foodToAdd.name, foodToAdd.foodType, foodToAdd.iconName], [result.name, result.foodType, result.iconName], "Problems with searching food by name")
        
    }
    
    func testFoodAddingByName() {
        let foodForAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodForAdd)
        
        let wasAdded = testableDataSource.addFood(byName: validFoodName)
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testFoodAddingByQR() {
        let foodForAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodForAdd)
        
        let wasAdded = testableDataSource.addFood(byQR: validQRCodeInfo)
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testGetingCorrectItemCount() {
        let foodForAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodForAdd)
        
        let numberOfElementsBeforeTest = testableDataSource.getFoodItemCount()
        let _ = testableDataSource.addFood(byName: validFoodName)
        let numberOfElementsAfterTest = testableDataSource.getFoodItemCount()
        XCTAssertGreaterThan(numberOfElementsAfterTest, numberOfElementsBeforeTest, "Problems with correct item counting")
    }
    
    func testCorrectItemReturning() {
        let foodForAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodForAdd)
        
        let _ = testableDataSource.addFood(byName: validFoodName)
        let numbersOfItemsInDB = testableDataSource.getFoodItemCount()
        let indexPath = IndexPath(item: numbersOfItemsInDB - 1, section: 0)
        let itemInDB = testableDataSource.getFood(at: indexPath)
        XCTAssertEqual(itemInDB.name, validFoodName, "Problems with getting correct item from UserFood")
    }
    
    func testDeletingUserFood() {
        let _ = testableDataSource.addFood(byName: validFoodName)
        let numberOfFoodElements = testableDataSource.getFoodItemCount()
        let _ = testableDataSource.addFood(byName: validFoodName)
        let addedFood = testableDataSource.getFood(at: IndexPath(item: numberOfFoodElements - 1, section: 0))
        testableDataSource.delete(food: addedFood)
        XCTAssertEqual(numberOfFoodElements, testableDataSource.getFoodItemCount(), "Problems with deleting of food")
    }
    
    func testGetAllFoodByType() {
        let resultBeforeAdding = testableDataSource.getAllFood(by: userAddedFoodType)
        let foodForAdd = generateSampleAddedUserFood()
        
        testableDataSource.addUserCreatedFood(foodForAdd)
        
        let result = testableDataSource.getAllFood(by: userAddedFoodType)
        
        XCTAssertGreaterThan(result.count, resultBeforeAdding.count, "Error with getting food by type")
    }
    
    func testAddingFoodByUser() {
        testableDataSource.addUserCreatedFood(generateSampleAddedUserFood())
        
        let result = testableDataSource.addFood(byName: validFoodName)
        XCTAssert(result, "Problems with adding User Food")
    }
    
    func testGettingFulInfoAboutUserAddedFood() {
        testableDataSource.addUserCreatedFood(generateSampleAddedUserFood())
        let info = testableDataSource.getFulInfo(about: generateSampleAddedUserFood())
        XCTAssertEqual(info!.name, validFoodName, "Problems with deleting correct info about user added food")
    }
    
    func testModificationUserCreatedFood() {
        testableDataSource.addUserCreatedFood(generateSampleAddedUserFood())
        let food = testableDataSource.getFulInfo(about: generateSampleAddedUserFood())!
        let newInfo = AddedUserFood()
        newInfo.name = "Test 2"
        newInfo.foodType = food.foodType
        newInfo.iconName = food.iconName
        newInfo.qrCode = food.qrCode
        newInfo.shelfLife = food.shelfLife
        
        testableDataSource.modifyUserCreatedFood(food, withInfo: newInfo)
        
        let addedFoodArray = testableDataSource.getAllFood(by: userAddedFoodType)
        guard let addedElementName = addedFoodArray.last?.name else {
            XCTFail("Unable to find data after adding")
            return
        }
        
        XCTAssertEqual(addedElementName, "Test 2", "Problems with modification of element, find \(addedElementName)")

    }
    
    func testDeleteAllUserInfo() {
        testableDataSource.deleteAllUserInfo()
        XCTAssertEqual(testableDataSource.getFoodItemCount(), 0, "Problems with deleting user info")

    }
    
    func testPerformanceOfSearchingByName() {
        self.measure {
            let _ = self.testableDataSource.addFood(byName: validFoodName)
        }
    }
    
    func testPerformanceOfSearchingByQR() {
        self.measure {
            let _ = self.testableDataSource.addFood(byQR: validQRCodeInfo)
        }
    }
    
    func testPerformanceOfFindingAllUserAddedFood() {
        self.measure {
            let _ = self.testableDataSource.getAllFood(by: userAddedFoodType)
        }
    }


    
}

class BaseUserFoodDataSourceTests: XCTestCase {
    
    var testableDataSource: BaseUserFoodDataSource!
    
    
    override func setUp() {
        super.setUp()
        do {
            testableDataSource = try BaseUserFoodDataSource()
        } catch let error as NSError {
            fatalError("***Error: \(error)")
        }
        
    }
    
    override func tearDown() {
        testableDataSource = nil
        super.tearDown()
    }

    func testGetAllFoodTypes() {
        let result = testableDataSource.getAllFoodTypes()
        XCTAssertNotEqual(result.count, 0, "Problems with finding food types (BaseFoodDataSource)")
    }
    
    func testGetAllFoodByType() {
        let result = testableDataSource.getAllFood(by: "Bread")
        XCTAssertNotEqual(result.count, 0, "Problems with finding food with corresponding type (BaseFoodDataSource)")
    }
    
    func testFindFoodByName() {
        let food = testableDataSource.findFoodBy(name: validFoodName)
        XCTAssertNotNil(food, "Can't find food by name (BaseFoodDataSource)")
    }
    
    func testFindFoodByQR() {
        let food = testableDataSource.findFoodBy(qr: validQRCodeInfo)
        XCTAssertNotNil(food, "Can't find food by qr (BaseFoodDataSource)")
    }

}
