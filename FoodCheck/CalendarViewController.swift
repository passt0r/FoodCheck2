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
    
    let monthHeaderView = "MounthHeaderView"
    let calendarCellID = "CalendarItemCell"
    let foodAtDateCellID = "FoodAtDateCell"
    let smallRowHeight:CGFloat = 44
    let formatter = DateFormatter()
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var foodTable: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var dataSource: MutableFoodDataSource!
    
    var selectedDate: Date = Date()
    var foodThatShelfLifeEndAtSelectedDate: [UserFood] = [UserFood]()
    var foodForMonth: [UserFood] = [UserFood]()

    override func viewDidLoad() {
        super.viewDidLoad()
        startPreparing()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startPreparing() {
        view.setBackground(image: backgroundImage!)
        
        //dataSource preparetions
        foodThatShelfLifeEndAtSelectedDate = dataSource.getFood(with: selectedDate)
        
        prepareLabels()
        prepareTableView()
        prepareCalendarView()
    }
    
    private func prepareLabels() {
        yearLabel.textColor = peachTint//UIColor(red: 240/255, green: 140/255, blue: 60/255, alpha: 1.0)
        monthLabel.textColor = grassGreen
    }
    
    private func prepareTableView() {
        foodTable.dataSource = self
        foodTable.delegate = self
        
        foodTable.backgroundColor = UIColor.clear
    }
    
    private func prepareCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
//        calendar.backgroundColor = UIColor.clear
        calendar.layer.cornerRadius = 20
        
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
            let components = DateComponents(year: 2)
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
        cell.layer.cornerRadius = 5
        
        changeSelection(of: cell, with: cellState, at: date)
        //TODO: if any food at this date end it's shelf life, than make cproperty visible: 
        //cell.dotUnderDate.isHidden = false
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: monthHeaderView, for: indexPath) as! CalendarHeaderView
        headerView.setTextColor(to: grassGreen)
        
        foodForMonth = dataSource.getFood(fromDate: range.start, toDate: range.end)
        
        return headerView
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CalendarItemCell else { return }
        changeSelection(of: selectedCell, with: cellState, at: date)
        foodTable.beginUpdates()
        deleteRowsFromPreviousSelection()
        //get new date from selected index
        selectedDate = date
        //get new food from new date
        foodThatShelfLifeEndAtSelectedDate = dataSource.getFood(with: selectedDate)
        //insert new rows
        insertRowsFronNewSelection()
        foodTable.endUpdates()
        
        cell?.bounce()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CalendarItemCell else { return }
        changeSelection(of: selectedCell, with: cellState, at: date)
    }
    
    private func changeSelection(of cell: CalendarItemCell, with state: CellState, at date: Date) {
        if state.isSelected {
            cell.backgroundColor = peachTint
            cell.dateLabel.textColor = UIColor.white
            cell.dotUnderDate.textColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.clear
            cell.dateLabel.textColor = peachTint
            cell.dotUnderDate.textColor = peachTint
            }
    }
    
    //TODO: Fix this to check insertion from empty array
    private func deleteRowsFromPreviousSelection() {
        //delete previous rows with animations
        var rowsForDeleting = [IndexPath]()
        for food in foodThatShelfLifeEndAtSelectedDate {
            guard let rowIndex = foodThatShelfLifeEndAtSelectedDate.index(of: food) else { return }
            //MARK: if remove must be here?
            foodThatShelfLifeEndAtSelectedDate.remove(at: rowIndex)
            let indexPath = IndexPath(row: rowIndex, section: 0)
            rowsForDeleting.append(indexPath)
        }

        foodTable.deleteRows(at: rowsForDeleting, with: .fade)
    }
    
    private func insertRowsFronNewSelection() {
        //insert new rows
        var rowsForInserting = [IndexPath]()
        for food in foodThatShelfLifeEndAtSelectedDate {
            guard let rowIndex = foodThatShelfLifeEndAtSelectedDate.index(of: food) else { return }
            let indexPath = IndexPath(row: rowIndex, section: 0)
            rowsForInserting.append(indexPath)
        }
        foodTable.insertRows(at: rowsForInserting, with: .right)
    }
    
}

extension CalendarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodThatShelfLifeEndAtSelectedDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodAtDateCellID, for: indexPath) as! FoodAtDateTableViewCell
        let foodForRow = foodThatShelfLifeEndAtSelectedDate[indexPath.row]
        cell.foodNameLabel.text = foodForRow.name
        cell.foodIcon.image = icon(for: foodForRow)
        
        return cell
    }
}

extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //it will be small row
        return smallRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = foodThatShelfLifeEndAtSelectedDate[indexPath.row]
        dataSource.delete(food: selectedFood)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
