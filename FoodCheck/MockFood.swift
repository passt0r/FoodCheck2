//
//  MockFood.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 02.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class MockFood {
    let name: String
    let imageName: String
    
    static var elementsCount: Double = 0
    
    let dateTo = Date(timeIntervalSinceNow: 100 + MockFood.elementsCount)
    
    init(name: String, imageName: String) {
        self.name = name + " \(MockFood.elementsCount)"
        self.imageName = imageName
        MockFood.elementsCount += 1
    }
    
    func foodImage(for name: String) -> UIImage {
        guard let image = UIImage(named: name) else { return UIImage(named: "fruit")! }
        return image
    }
}
