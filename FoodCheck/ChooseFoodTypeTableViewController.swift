//
//  ChooseFoodTypeTableViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class ChooseFoodTypeTableViewController: UITableViewController {
    private let cellIdentifier = "FoodTypeCell"
    
    var dataSource: MutableFoodDataSource!
    weak var delegate: AddFoodToFridgeDelegate?
    
    private var foodTypes: [FoodType]!

    override func viewDidLoad() {
        super.viewDidLoad()
        startSetup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBackgroundView() {
        tableView.backgroundView = generateBackgroundImageView()
    }
    
    func startSetup() {
        setBackgroundView()
        tableView.rowHeight = heighForRow
        foodTypes = dataSource.getAllFoodTypes()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.getAllFoodTypes().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChooseFoodTypeTableViewCell

        // Configure the cell...
        var foodTypeName = foodTypes[indexPath.row].typeName
        let iconName = foodTypes[indexPath.row].typeIcon
        
        //get localized version of food name
        if let localizedFoodType = localizedFoodTypesArray[foodTypeName] {
            foodTypeName = localizedFoodType
        }
        cell.textLabel?.text = foodTypeName
        cell.textLabel?.backgroundColor = UIColor.clear
        guard let foodTypeImage = UIImage(named: iconName) else { return cell }
        cell.imageView?.image = foodTypeImage
        
        return cell
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChooseFood" {
            let senderRow = sender as! ChooseFoodTypeTableViewCell
            let selectedRow = tableView.indexPath(for: senderRow)!
            let selectedFoodType = foodTypes[selectedRow.row]
            let destination = segue.destination as! ChooseFoodTableViewController
            destination.dataSource = dataSource
            destination.delegate = delegate
            destination.choosedFoodType = selectedFoodType
        }
    }
    

}
