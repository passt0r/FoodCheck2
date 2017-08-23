//
//  CalendarViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 10.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    let calendarCellID = "CalendarItemCell"
    let foodAtDateCellID = "FoodAtDateCell"
    let formatter = DateFormatter()
    
    @IBOutlet weak var calendar: JTAppleCalendarView!
    @IBOutlet weak var foodTable: UITableView!
    
    var dataSource: MutableFoodDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.setBackground(image: backgroundImage!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startPreparing() {
//        foodTable.dataSource = self
//        foodTable.delegate = self

        calendar.backgroundColor = UIColor.clear
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalendarViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate: Date = {
            let currentDate = Date()
        
            let sixMonthAgoDateComponent = DateComponents(month: -6)
            let sixMonthAgoDateFirstDay = Calendar.Component.day
            let date = Calendar.current.date(byAdding: sixMonthAgoDateComponent, to: currentDate)!
            let firstDayOfHalfOfYearAgoDate = Calendar.current.date(bySetting: sixMonthAgoDateFirstDay, value: 1, of: date)!
            
            return firstDayOfHalfOfYearAgoDate
        }()
        
        let endDate: Date = {
            let components = DateComponents(year: 5)
            return Calendar.current.date(byAdding: components, to: startDate)!
        }()
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, calendar: Calendar.current, firstDayOfWeek: .monday)
        return parameters
    }
}

extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: calendarCellID, for: indexPath) as! CalendarItemCell
        cell.dateLabel.text = cellState.text
        
        return cell
    }
    
}

//extension CalendarViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//    }
//}
//
//extension CalendarViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//}
