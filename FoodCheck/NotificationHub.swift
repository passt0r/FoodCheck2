//
//  NotificationHub.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationHub: NSObject {
    private var isNotificationsEnable: Bool = false
    
    var dataSource: MutableFoodDataSource?
    
    func checkNotificationEnable() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { [weak self] isEnable, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error as NSError? {
                record(error: error)
            }
            
            strongSelf.isNotificationsEnable = isEnable
            
        })
        
    }
    
    func scheduleNotificationsToFuture(from date: Date, for days: Int) {
        deleteOldNotifications()
        
        guard let availableDataSource = dataSource else { return }
        
        let calendar = Calendar.current
        let beginOfDay = calendar.startOfDay(for: date)
        
        for day in 1...days {
            let nextDay: Date = {
                let dateComponent = DateComponents(day: day,second: 1)
                return calendar.date(byAdding: dateComponent, to: beginOfDay)!
            }()
            
            let foodItems = availableDataSource.getFood(with: nextDay)
            
            guard !foodItems.isEmpty else {
                return
            }
            addNewNotifications(at: nextDay, with: foodItems.count)
        }
    }
    
    func deleteOldNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func addNewNotifications(at date: Date, with foodCounts: Int) {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: dateComponents.month, day: dateComponents.day, hour: 9, minute: 0)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Food loss", comment: "Text for notification title")
        content.body = String(format: NSLocalizedString("Today end shelf life %@ product. Check your fridge to stay healthy!", comment: "Text for notification body"), arguments: [String(foodCounts)])
        content.sound = UNNotificationSound.default()
        
        let request = UNNotificationRequest(identifier: String(describing: date), content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (error)  in
            if let error = error as NSError? {
                record(error: error)
            }
        })
    }
    
}

extension NotificationHub: UNUserNotificationCenterDelegate {
    
}
