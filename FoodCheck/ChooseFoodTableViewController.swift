//
//  ChooseFoodTableViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 20.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class ChooseFoodTableViewController: UITableViewController, FoodSearchingController {
    
    private let addUserFoodCellIdentifier = "AddUserFood"
    private let foodByTypeCellIdentifier = "FoodByType"
    
    private let emptyMassage = NSLocalizedString("Seems like this category is empty", comment: "Massage for empty food by type screen")
    
    var dataSource: MutableFoodDataSource!
    weak var delegate: AddFoodToFridgeDelegate?
    
    var choosedFoodType: FoodType!
    
    private var foodByType: [UserFoodInformation]!
    
    var isUserAddedType = false
    
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
    
    private func startSetup() {
        setBackgroundView()
        tableView.rowHeight = heighForRow
        checkIfTypeIsUserAdded()
        foodByType = dataSource.getAllFood(by: choosedFoodType.typeName)
        emptyTypeMessage()
    }
    
    private func emptyTypeMessage() {
        if foodByType.count == 0 {
            let messageLabel = generateMassageLabel()
            let message = emptyMassage
            view.addSubview(messageLabel)
            messageLabel.setupMessage(with: message)
        }
    }
    
    private func setBackgroundView() {
        tableView.backgroundView = generateBackgroundImageView()
    }
    
    private func checkIfTypeIsUserAdded() {
        if choosedFoodType.typeName == "User Added" {
            isUserAddedType = true
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isUserAddedType {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isUserAddedType {
            if section == 0 {
                return 1
            } else {
                return foodByType.count
            }
        } else {
            return foodByType.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isUserAddedType {
            if section == 0 {
                return 0
            }
        }
        return 24
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isUserAddedType {
            if section == 0 {
                return nil
            }
        }
        
        let backgroundHeaderView = UIView()
        backgroundHeaderView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        backgroundHeaderView.frame = tableView.rectForHeader(inSection: section)
        prepareHeaderLabel(forBackground: backgroundHeaderView)
        
        return backgroundHeaderView
    }
    
    private func prepareHeaderLabel(forBackground view: UIView){
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = peachTint
        if let localizedFoodType = localizedFoodTypesArray[choosedFoodType.typeName] {
            label.text = localizedFoodType
        } else {
            label.text = choosedFoodType.typeName
        }
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isUserAddedType {
            if section == 0 {
                return nil
            }
        }
        return localizedFoodTypesArray[choosedFoodType.typeName]
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isUserAddedType {
            if indexPath.section == 0 && indexPath.row == 0 {
               return configuratedAddUserFoodCell(at: indexPath)
            }
        }
        
        return configuratedFoodByTypeCell(at: indexPath)
    }
    
    private func configuratedAddUserFoodCell(at indexPath: IndexPath) -> AddFoodTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addUserFoodCellIdentifier, for: indexPath) as! AddFoodTableViewCell
        
        return cell
    }
    
    private func configuratedFoodByTypeCell(at indexPath: IndexPath) -> ChooseFoodTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodByTypeCellIdentifier, for: indexPath) as! ChooseFoodTableViewCell
        
        let findedFood = foodByType[indexPath.row]
        cell.textLabel?.text = findedFood.name
        cell.textLabel?.backgroundColor = UIColor.clear
        guard let foodTypeImage = UIImage(named: findedFood.iconName) else { return cell }
        cell.imageView?.image = foodTypeImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFood = foodByType[indexPath.row]
        performSearch(withInfo: selectedFood.name)
    }
    
    func performSearch(withInfo info: String) {
        let added = dataSource.addFood(byName: info)
        delegate?.foodAddToFridge(self, successfuly: added)
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
    //TODO: Add support of modification of food
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "AddNewFood":
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.topViewController as! AddFoodTableViewController
            destination.dataSource = dataSource
            destination.delegate = self
        default:
            let error = NSError(domain: "ChooseFoodSegueError", code: 1, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)

        }
    }
}

extension ChooseFoodTableViewController: AddNewFoodDelegate {
    func addOrChangeFood(_ source: MutatingUserAddedFoodController, successfully added: Bool) {
        if added {
            tableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
}
