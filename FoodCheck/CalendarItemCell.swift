//
//  CalendarItemCell.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 23.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarItemCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dotUnderDate: UILabel!
    
    enum selectedState {
        case Selected
        case NotSelected
        case TodayCell
    }

}
