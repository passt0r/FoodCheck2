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
    let smallRowHeight:CGFloat = 55
    let formatter = DateFormatter()
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var foodTable: UITableView!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var dataSource: MutableFoodDataSource!
    
    var selectedDate: Date = Date()
    let todayDate: Date = Date()
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
        prepareStartInfo()
        
        prepareLabels()
        prepareTableView()
        prepareCalendarView()
    }
    
    private func prepareLabels() {
        yearLabel.textColor = peachTint
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
        
        calendarView.visibleDates({ visibleDates in
            self.changeMonthAndYearLabels(from: visibleDates)
        })
        calendarView.scrollToDate(todayDate, animateScroll: false)
        calendarView.selectDates([todayDate])
    }
    
    private func prepareStartInfo() {
        
        let monthComponent = Calendar.Component.month
        guard let dates = Calendar.current.dateInterval(of: monthComponent, for: todayDate) else {
            return
        }
        
        foodForMonth = dataSource.getFood(fromDate: dates.start, toDate: dates.end)
        foodThatShelfLifeEndAtSelectedDate = dataSource.getFood(with: todayDate)
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier ?? "") {
        case "Show_app_info":
            let destination = segue.destination as! AboutAppTableViewController
            destination.dataSource = dataSource
        case "UnwindFromCalendar":
            break
        default :
            let error = NSError(domain: "CalendarSegueError", code: 1, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)
        }
    }
    

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
        
            let sixMonthAgoDateComponent = DateComponents(month: -2)
            let sixMonthAgoDateFirstDay = Calendar.Component.day
            let date = Calendar.current.date(byAdding: sixMonthAgoDateComponent, to: currentDate)!
            let firstDayOfHalfOfYearAgoDate = Calendar.current.date(bySetting: sixMonthAgoDateFirstDay, value: 2, of: date)!
            
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
        
        markIfFoodEndShelfLife(cell, at: cellState.date)
        
        return cell
    }

    private func markIfFoodEndShelfLife(_ cell: CalendarItemCell, at date: Date) {
        formatter.dateFormat = "dd MM yyyy"
        let dateString = formatter.string(from: date)
        var wasFound = false
        //MARK: problem in food for month
        for food in foodForMonth {
            let endDateString = formatter.string(from: food.endDate)
            if endDateString == dateString {
                cell.dotUnderDate.isHidden = false
                wasFound = true
                break
            }
        }
        if !wasFound {
            cell.dotUnderDate.isHidden = true
        }

    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let headerView = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: monthHeaderView, for: indexPath) as! CalendarHeaderView
        headerView.setTextColor(to: grassGreen)
        
        return headerView
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        changeMonthAndYearLabels(from: visibleDates)
    }
    
    private func getFoodForVisibleDates(from visibleDates: DateSegmentInfo) {
        guard let firstVisibleDate = visibleDates.indates.first?.date else { return }
        guard let lastVisibleDate = visibleDates.outdates.last?.date else { return  }
        
        foodForMonth = dataSource.getFood(fromDate: firstVisibleDate, toDate: lastVisibleDate)
    }
    
    func changeMonthAndYearLabels(from visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return  }
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
        
        getFoodForVisibleDates(from: visibleDates)
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 40)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let selectedCell = cell as? CalendarItemCell else { return }
        changeSelection(of: selectedCell, with: cellState, at: date)
        foodTable.beginUpdates()
        deleteRowsFromPreviousSelection()
        
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
            if state.dateBelongsTo == .thisMonth {
                checkIfToday(cell: cell, at: date)
            } else {
                cell.dateLabel.textColor = peachTint(withAlpha: 0.5)
            }
            cell.backgroundColor = UIColor.clear
            cell.dotUnderDate.textColor = grassGreen
            }
    }
    
    private func checkIfToday(cell: CalendarItemCell, at date: Date) {
        formatter.dateFormat = "dd MM yyyy"
        let todayDateString = formatter.string(from: todayDate)
        let cellDateString = formatter.string(from: date)
        if cellDateString == todayDateString {
            cell.dateLabel.textColor = grassGreen
        } else {
            cell.dateLabel.textColor = peachTint
        }
    }
    
    private func deleteRowsFromPreviousSelection() {
        //delete previous rows with animations
        var rowsForDeleting = [IndexPath]()
        for food in foodThatShelfLifeEndAtSelectedDate {
            guard let rowIndex = foodThatShelfLifeEndAtSelectedDate.index(of: food) else { return }
            let indexPath = IndexPath(row: rowIndex, section: 0)
            rowsForDeleting.append(indexPath)
        }
        foodThatShelfLifeEndAtSelectedDate.removeAll()
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
        foodTable.insertRows(at: rowsForInserting, with: .fade)
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
        deleteFood(selectedFood)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    private func deleteFood(_ food: UserFood) {
        guard let indexAtSelectedDate = foodThatShelfLifeEndAtSelectedDate.index(of: food) else { return }
        guard let indexAtMonthFood = foodForMonth.index(of: food) else { return }
        foodThatShelfLifeEndAtSelectedDate.remove(at: indexAtSelectedDate)
        foodForMonth.remove(at: indexAtMonthFood)
        dataSource.delete(food: food)
        
        reloadSelectedDateCell()
    }
    
    private func reloadSelectedDateCell() {
        guard let selectedDate = calendarView.selectedDates.first else { return }
        calendarView.reloadDates([selectedDate])
    }
}
