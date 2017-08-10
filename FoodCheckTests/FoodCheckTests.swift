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
let validQRCodeInfo = "kek"
let validFoodName = "Milk"
let validIconName = "fruit"

class FoodDataSourceTests: XCTestCase {
    var testableDataSource: FoodDataSource!
    
    func generateSampleFood() -> UserFood {
        let testExample = UserFood()
        testExample.name = "Test"
        testExample.iconName = validIconName
        testExample.endDate = Date(timeIntervalSinceNow: 10)
        
        return testExample
    }
    
    func generateSampleAddedUserFood() -> AddedUserFood {
        let testExample = AddedUserFood()
        testExample.name = "Test"
        testExample.foodType = "Milk"
        testExample.iconName = validIconName
        testExample.shelfLife = 1
        testExample.qrCode = validQRCodeInfo
        
        return testExample
    }
    
    override func setUp() {
        super.setUp()
        do {
            testableDataSource = try FoodDataSource()
        } catch let error as NSError {
            fatalError("***Error: \(error)")
        }
        
    }
    
    override func tearDown() {
        testableDataSource.deleteAllUserInfo()
        testableDataSource = nil
        super.tearDown()
    }
    
    func testGettingFoodTypes() {
        let result = testableDataSource.getAllFoodTypes()
        XCTAssertNotEqual(result.count, 0, "Problems with finding food types")
        
    }
    
    func testGettingFoodByType() {
        let result = testableDataSource.getAllFood(by: "Bread")
        XCTAssertNotEqual(result.count, 0, "Problems with finding food with corresponding type")
    }
    
    func testFoodAddingByName() {
        let wasAdded = testableDataSource.addFood(byName: "Milk")
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testFoodAddingByQR() {
        //FIXME: add valid code for this test
        let wasAdded = testableDataSource.addFood(byQR: validQRCodeInfo)
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testGetingCorrectItemCount() {
        let numberOfElementsBeforeTest = testableDataSource.getFoodItemCount()
        let _ = testableDataSource.addFood(byName: "Fruit")
        let numberOfElementsAfterTest = testableDataSource.getFoodItemCount()
        XCTAssertGreaterThan(numberOfElementsAfterTest, numberOfElementsBeforeTest, "Problems with correct item counting")
    }
    
    func testCorrectItemReturning() {
        let _ = testableDataSource.addFood(byName: "Fruit")
        let numbersOfItemsInDB = testableDataSource.getFoodItemCount()
        let indexPath = IndexPath(item: numbersOfItemsInDB - 1, section: 0)
        let itemInDB = testableDataSource.getFood(at: indexPath)
        XCTAssertEqual(itemInDB.name, "Fruit", "Problems with getting correct item from UserFood")
    }
    
    func testDeletingUserFood() {
        let numberOfFoodElements = testableDataSource.getFoodItemCount()
        let _ = testableDataSource.addFood(byName: "Fruit")
        let addedFood = testableDataSource.getFood(at: IndexPath(item: numberOfFoodElements - 1, section: 0))
        testableDataSource.delete(food: addedFood)
        XCTAssertEqual(numberOfFoodElements, testableDataSource.getFoodItemCount(), "Problems with deleting of food")
    }
    
    func testAddingFoodByUser() {
        let testExample = AddedUserFood()
        testExample.name = "Test"
        testExample.foodType = "Milk"
        testExample.iconName = "butter"
        testExample.shelfLife = 1
        testExample.qrCode = validQRCodeInfo
        
        testableDataSource.addUserCreatedFood(testExample)
        
        let result = testableDataSource.addFood(byName: "Test")
        XCTAssert(result, "Problems with adding User Food")
    }
    
    func testGettingFulInfoAboutUserAddedFood() {
        testableDataSource.addUserCreatedFood(generateSampleAddedUserFood())
        let info = testableDataSource.getFulInfo(about: generateSampleAddedUserFood())
        XCTAssertEqual(info.name, "Test", "Problems with deleting correct info about user added food")
    }
    
    func testModificationUserCreatedFood() {
        testableDataSource.addUserCreatedFood(generateSampleAddedUserFood())
        let food = testableDataSource.getFulInfo(about: generateSampleAddedUserFood())
        food.name = "Test 2"
        
        let addedFoodArray = testableDataSource.getAllFood(by: "User Added")
        let addedElementName = addedFoodArray.last?.name
        XCTAssertEqual(addedElementName!, "Test 2", "Problems with modification of element")
        
    }
    
    
    func testDeleteAllUserInfo() {
        testableDataSource.deleteAllUserInfo()
        XCTAssertEqual(testableDataSource.getFoodItemCount(), 0, "Problems with deleting user info")
    }
    
    func testPerformanceOfSearchingByName() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testPerformanceOfSearchingByQR() {
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

class UserDataSourceTests: XCTestCase {
    
    var testableDataSource: UserDataSource!
    
    
    override func setUp() {
        super.setUp()
        do {
            let defaultBD = try BaseUserFoodDataSource()
            testableDataSource = try UserDataSource(with: defaultBD)
        } catch let error as NSError {
            fatalError("***Error: \(error)")
        }
        
    }
    
    override func tearDown() {
        testableDataSource.deleteAllUserInfo()
        testableDataSource = nil
        super.tearDown()
    }
    
    func testFoodAddingByName() {
        let wasAdded = testableDataSource.addFood(byName: "Milk")
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testFoodAddingByQR() {
        //FIXME: add valid code for this test
        let wasAdded = testableDataSource.addFood(byQR: "Some code")
        XCTAssert(wasAdded, "Problems with adding food by name")
    }
    
    func testGetingCorrectItemCount() {
        let numberOfElementsBeforeTest = testableDataSource.getFoodItemCount()
        let _ = testableDataSource.addFood(byName: "Fruit")
        let numberOfElementsAfterTest = testableDataSource.getFoodItemCount()
        XCTAssertGreaterThan(numberOfElementsAfterTest, numberOfElementsBeforeTest, "Problems with correct item counting")
    }
    
    func testCorrectItemReturning() {
        let _ = testableDataSource.addFood(byName: "Fruit")
        let numbersOfItemsInDB = testableDataSource.getFoodItemCount()
        let indexPath = IndexPath(item: numbersOfItemsInDB - 1, section: 0)
        let itemInDB = testableDataSource.getFood(at: indexPath)
        XCTAssertEqual(itemInDB.name, "Fruit", "Problems with getting correct item from UserFood")
    }
    
    func testDeletingUserFood() {
        
    }
    
    func testAddingFoodByUser() {
        
    }
    
    func testGettingFulInfoAboutUserAddedFood() {
        
    }
    
    func testModificationUserCreatedFood() {
        
    }
    
    func testDeleteAllUserInfo() {
        
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
        let food = testableDataSource.findFoodBy(name: "Bread")
        XCTAssertNotNil(food, "Can't find food by name (BaseFoodDataSource)")
    }
    
    func testFindFoodByQR() {
        let food = testableDataSource.findFoodBy(qr: validQRCodeInfo)
        XCTAssertNotNil(food, "Can't find food by qr (BaseFoodDataSource)")
    }

}
