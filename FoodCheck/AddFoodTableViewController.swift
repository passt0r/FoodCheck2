//
//  AddFoodTableViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 21.08.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

class AddFoodTableViewController: UITableViewController, MutatingUserAddedFoodController {
    
    @IBOutlet weak var addFoodButton: UIBarButtonItem!
    
    @IBOutlet weak var foodNameField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var shelfLifeField: UITextField!
    @IBOutlet weak var qrCodeAddedLabel: UILabel!
    
    var dataSource: MutableFoodDataSource!
    weak var delegate: AddNewFoodDelegate!
    
    var modifiedUserFood: AddedUserFood?
    
    var isModifing = false
    
    private enum qrCodeAddedStatus: String {
        case Added = "added"
        case NotAdded = "not_added"
    }
    
    private let qrCodeLabelStatusMessage: [qrCodeAddedStatus: String] = [
        .Added: NSLocalizedString("Added", comment: "Message at qr code label status on added"),
        .NotAdded: NSLocalizedString("Not Added", comment: "Message at qr code label status on not added")
    ]
    
    private let headerOfScreen: [Bool: String] = [
        false: NSLocalizedString("Add Food", comment: "Header message when add new food on AddFoodTableViewController"),
        true: NSLocalizedString("Modify Food", comment: "Header message when modify exist food on AddFoodTableViewController")
    ]
    
    var iconName: String = baseFoodIconName
    var qrCode: String? = nil
    
    private var typePickerVisible = false
    
    @IBAction func cancelAdding(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userDoneEnterInfo(_ sender: UIBarButtonItem) {
        if checkIfAddingAvailable() {
            if isModifing {
                modifyUserAddedFood()
            } else {
                addNewUserFood()
            }
        } else {
           let error = NSError(domain: "AddFoodTableUserDoneEnterError", code: 1, userInfo: nil)
            record(error: error)
        }
    }
    
    @IBAction func unwindToAddUserFood(segue: UIStoryboardSegue) {
        switch (segue.identifier ?? "") {
        case "FromChooseIcon":
            let source = segue.source as! AddIconTableViewController
            let choosedIconName = source.choosedIconName
            iconName = choosedIconName
            iconImageView.image = UIImage(named: iconName)
        default:
            let error = NSError(domain: "AddFoodTableViewControllerError", code: 2, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)
        }
    }

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
        iconImageView.image = UIImage(named: iconName)
        if let _ = qrCode {
            qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.Added]
            qrCodeAddedLabel.textColor = grassGreen
        } else {
            qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.NotAdded]
            qrCodeAddedLabel.textColor = peachTint
        }
        navigationItem.title = headerOfScreen[isModifing]!
        let _ = checkIfAddingAvailable()
    }
    
    private func setBackgroundView() {
        tableView.backgroundView = generateBackgroundImageView()
    }
    
    func checkIfAddingAvailable() -> Bool {
        //TODO: implement valid checking of posibility to add food
        guard let foodName = foodNameField.text else { return false }
        guard !foodName.isEmpty else {
            return false
        }
        
        addFoodButton.isEnabled = true
        return true
    }
    
    func addNewUserFood() {
        let newFood = createNewUserFood()
        dataSource.addUserCreatedFood(newFood)
        delegate.addOrChangeFood(self, successfully: true)
    }
    
    func modifyUserAddedFood() {
        guard let userModifiedFood = modifiedUserFood else {
            let error = NSError(domain: "AddFoodTableModifiingError", code: 1, userInfo: nil)
            record(error: error)
            return
        }
        let newInfo = createNewUserFood()
        dataSource.modifyUserCreatedFood(userModifiedFood, withInfo: newInfo)
        delegate.addOrChangeFood(self, successfully: true)
    }
    
    func createNewUserFood() -> AddedUserFood {
        //TODO: add new user food from info from screen
        return AddedUserFood()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

extension AddFoodTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let _ = checkIfAddingAvailable()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addFoodButton.isEnabled = false
    }
}
