//
//  CalendarHeaderView.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 23.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarHeaderView: JTAppleCollectionReusableView {
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tueLabel: UILabel!
    @IBOutlet weak var wenLabel: UILabel!
    @IBOutlet weak var thuLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    @IBOutlet weak var sunLabel: UILabel!
    
    func setTextColor(to color: UIColor) {
        monLabel.textColor = color
        tueLabel.textColor = color
        wenLabel.textColor = color
        thuLabel.textColor = color
        friLabel.textColor = color
        satLabel.textColor = color
        sunLabel.textColor = color
    }

}
