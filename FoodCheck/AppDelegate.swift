//
//  AppDelegate.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 05.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dataSource: MutableFoodDataSource!
    
    func customizeAppearance() {
       window?.tintColor = peachTint
        UINavigationBar.appearance().titleTextAttributes =
            [NSForegroundColorAttributeName: grassGreen]
        UILabel.appearance().textColor = peachTint
        
    }
    
    var launchAlert: UIAlertController?
    
    func initialDataSource() {
        do {
            dataSource = try UserDataSource()
        }
        catch let error as NSError {
            fatalRealmError(error)
        }
    }
    
    func listenForRealmErrorNotification() {
        NotificationCenter.default.addObserver(forName: MyDataModelDidFailNotification, object: nil, queue: OperationQueue.main, using: { notification in
            let alert = UIAlertController(title: NSLocalizedString("Internal alert", comment: "Internal error header"),
                                          message: NSLocalizedString("There was an error while working whith your data", comment: "Internal error description") + "\n\n" + NSLocalizedString("Press OK to terminate the app. Sorry for the inconvenience", comment: "Internal error excuses"),
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Agree button on internal error"), style: .default, handler: {_ in
                let exeption = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Realm error", userInfo: nil)
                exeption.raise()
            })
            alert.addAction(action)
            print("***Observe error")
            self.launchAlert = alert
            self.viewControllerForShowingAlert().present(alert, animated: true, completion: nil)
        })
    }
    
    func viewControllerForShowingAlert() -> UIViewController {
        let rootViewController = self.window!.rootViewController!
        return topViewController(from: rootViewController)
    }
    
    func topViewController(from controller: UIViewController) -> UIViewController {
        if controller is UINavigationController {
            return topViewController(from: (controller as! UINavigationController).topViewController!)
        }
        if controller is UITabBarController {
            return topViewController(from:(controller as! UITabBarController).selectedViewController!)
        }
        if let presentedViewController = controller.presentedViewController {
            return topViewController(from:presentedViewController)
        }
        
        return controller
    }
    
    private func registerDefaults() {
        let defaultsDictionary: [String: Any] = [
            numbersOfLaunch:0,
            willShowRaitingAlert:true,
            isFirstLaunch:true
        ]
        
        UserDefaults.standard.register(defaults: defaultsDictionary)
    }
    
    private func handleFirstTimeLaunch() {
        //TODO: In next version of app add first time presentation of app
    }
    
    private func handleAppRaiting() {
        let userDefaults = UserDefaults.standard
        let willShowRaiting = userDefaults.bool(forKey: willShowRaitingAlert)
        guard willShowRaiting else {
            return
        }
        
        let numberOfLaunch = userDefaults.integer(forKey: numbersOfLaunch)
        guard numberOfLaunch % 4 == 0 else {
            return
        }
        
        showAppRatingAlert()
    }
    
    private func showAppRatingAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Rate Us", comment: "Title for rate us alert"), message: NSLocalizedString("Do you like our app?\nIf so, rate us!", comment: "Message for rate us alert"), preferredStyle: .alert)
        let no = UIAlertAction(title: NSLocalizedString("No", comment: "Title for no action on rate us alert"), style: .default, handler: { _ in
            UserDefaults.standard.set(false, forKey: willShowRaitingAlert)
            UserDefaults.standard.synchronize()
        })
        let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: "Title for yes action on rate us alert"), style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.showRaitingAlert()
            UserDefaults.standard.set(false, forKey: willShowRaitingAlert)
            UserDefaults.standard.synchronize()
        })
        let later = UIAlertAction(title: NSLocalizedString("Later", comment: "Title for later action on rate us alert"), style: .cancel, handler: nil)
        
        alert.addAction(yes)
        alert.addAction(no)
        alert.addAction(later)
        
        viewControllerForShowingAlert().present(alert, animated: true, completion: nil)
    }
    
    private func showRaitingAlert() {
        SKStoreReviewController.requestReview()
    }
    
    private func handleNewLaunch() {
        let userDefaults = UserDefaults.standard
        let previousLaunchCount = userDefaults.integer(forKey: numbersOfLaunch)
        userDefaults.set(previousLaunchCount + 1, forKey: numbersOfLaunch)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeAppearance()
        registerDefaults()
        handleNewLaunch()
        
        listenForRealmErrorNotification()
        initialDataSource()
        
        if let rootViewController = window?.rootViewController as? UINavigationController {
            let rootContentController = rootViewController.viewControllers[0] as! YourFoodViewController
            rootContentController.dataSource = dataSource
        }
        
        Fabric.with([Crashlytics.self])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let presentLaunchAlert = launchAlert {
            viewControllerForShowingAlert().present(presentLaunchAlert, animated: true, completion: nil)
            launchAlert = nil
        }
        
        handleAppRaiting()
//        handleFirstTimeLaunch()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

