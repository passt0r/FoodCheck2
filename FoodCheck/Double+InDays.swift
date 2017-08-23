//
//  Double+InDays.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 23.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import Foundation

extension Double {
    func inDays() -> Int {
        return Int(self/secondsInDay)
    }
}
