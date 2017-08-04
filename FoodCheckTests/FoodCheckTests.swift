//
//  FoodCheckTests.swift
//  FoodCheckTests
//
//  Created by Dmytro Pasinchuk on 02.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import XCTest

@testable import FoodCheck

class FoodCheckTests: XCTestCase {
    var testableDataSource = MockFoodDataSource()
    
    
    override func setUp() {
        super.setUp()
            for _ in 0...5 {
            let newFoodElement = MockFood(name: "Food", imageName: "fruit")
            testableDataSource.add(element: newFoodElement)
        }
        let newFoodElement = MockFood(name: "Food", imageName: "apple")
        testableDataSource.add(element: newFoodElement)
        
    }
    
    override func tearDown() {
        testableDataSource.deleteAllFood()
        MockFood.elementsCount = 0
        super.tearDown()
    }
    
    func testFoodArrayCreated() {
        XCTAssert(testableDataSource.foodCount() != 0)
    }
    
    func testFoodDate() {
        XCTAssert(MockFood.elementsCount == 7)
    }
    
    func testFoodImage() {
        for testElement in testableDataSource.getFood() {
            let elementName = testElement.imageName
            XCTAssertNotNil(testElement.foodImage(for: elementName))
        }
    }
    
    func testDeletingFood() {
        testableDataSource.deleteFood(at: IndexPath(row: 0, section: 0))
        XCTAssert(testableDataSource.foodCount() == 6)
    }
    
    func testDeletingAllFood() {
        testableDataSource.deleteAllFood()
        XCTAssert(testableDataSource.foodCount() == 0)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
