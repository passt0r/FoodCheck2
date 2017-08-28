//
//  AboutAppTableViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 28.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class AboutAppTableViewController: UITableViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ratingButton: UIButton!
    @IBOutlet weak var deleteUserInfoButton: UIButton!
    
    var dataSource: MutableFoodDataSource!
    
    private let buttonCornerRadius:CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        startupPreparations()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startupPreparations() {
        tableView.backgroundView = generateBackgroundImageView()
    }
    
    private func prepareButtons() {
        ratingButton.layer.cornerRadius = buttonCornerRadius
        ratingButton.clipsToBounds = true
        
        deleteUserInfoButton.layer.cornerRadius = buttonCornerRadius
        ratingButton.clipsToBounds = true
        
        ratingButton.addTarget(self, action: #selector(rateApp), for: .touchDown)
        deleteUserInfoButton.addTarget(self, action: #selector(deleteUserInfo), for: .touchDown)
    }
    
    func prepareDescriptionCell() {
        
    }
    
    func rateApp() {
    
    }
    
    func deleteUserInfo() {
        
    }

//    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return 4
//    }
//
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.row == 0 {
//            let cell = configureDescription(cell: tableView.dequeueReusableCell(withIdentifier: aboutAppDescriptionCellIdentifier, for: indexPath) as! AboutDescriptionTableViewCell)
//            return cell
//        } else {
//            let cell = configureAction(cell: tableView.dequeueReusableCell(withIdentifier: actionButtonCellIdentifier, for: indexPath) as! AboutScreenButtonTableViewCell, at: indexPath)
//            return cell
//        }
//    }
//    
//    private func configureDescription(cell: AboutDescriptionTableViewCell) -> AboutDescriptionTableViewCell {
//        
//        
//        return cell
//    }
//    
//    private func configureAction(cell: AboutScreenButtonTableViewCell, at indexPath: IndexPath) -> AboutScreenButtonTableViewCell {
//        
//        
//        return cell
//    }
    
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
