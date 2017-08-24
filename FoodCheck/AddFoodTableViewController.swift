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
    
    private var isModifing = false
    
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
    
    //MARK: if add support of multiple food types, rewrite implementation and writing to choosedFoodType
    let choosedFoodType = "User Added"
    var iconName: String = baseFoodIconName {
        didSet {
            iconImageView.image = UIImage(named: iconName)
        }
    }
    var qrCode: String? = nil {
        didSet {
            if let _ = qrCode {
                qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.Added]
                qrCodeAddedLabel.textColor = grassGreen
            } else {
                qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.NotAdded]
                qrCodeAddedLabel.textColor = peachTint
            }
        }
    }
    
    var closeKeyboardTouchRecognizer: UITapGestureRecognizer?
    
    @IBAction func cancelAdding(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userDoneEnterInfo(_ sender: UIBarButtonItem) {
        //TODO: check if food with enter name exist, if so-show message
        if checkIfAddingAvailable() {
            if isModifing {
                modifyUserAddedFood()
            } else {
                if let existFoodWithEnterName = dataSource.findFoodBy(name: foodNameField.text!) {
                    showDublicateDataAlert(withDublicate: existFoodWithEnterName)
                } else {
                    addNewUserFood()
                }
            }
            
        } else {
            showInvalidDataAlert()
           let error = NSError(domain: "AddFoodTableUserDoneEnterError", code: 1, userInfo: nil)
            record(error: error)
        }
    }
    
    private func showInvalidDataAlert() {
        let alertController = UIAlertController(title: NSLocalizedString("Invalid data", comment: "Alert title while user enter invalid data for new food description"), message: NSLocalizedString("You have enter invalid data to new food.\nPlease, check your info and try again", comment: "Alert message while user enter invalid data for new food description"), preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("Ok", comment: "Action for user enter invalid data for new food description"), style: .default, handler: nil)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showDublicateDataAlert(withDublicate dublicate: AddedUserFood) {
        let alertController = UIAlertController(title: NSLocalizedString("Dublicate data", comment: "Alert title while user enter dublicate data for new food description"), message: NSLocalizedString("You have already food with this name.\nDo you want to rewrite it's data with new?", comment: "Alert message while user enter dublicate data for new food description"), preferredStyle: .alert)
        let actionYes = UIAlertAction(title: NSLocalizedString("Yes", comment: "Action approve for user enter rewrite data with new food description"), style: .destructive, handler: { _ in
            self.modifiedUserFood = dublicate
            self.modifyUserAddedFood()
        })
        let actionNo = UIAlertAction(title: NSLocalizedString("No", comment: "Action refusal for user enter rewrite data with new food description"), style: .cancel, handler: nil)
        alertController.addAction(actionNo)
        alertController.addAction(actionYes)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindToAddUserFood(segue: UIStoryboardSegue) {
        switch (segue.identifier ?? "") {
        case "FromChooseIcon":
            let source = segue.source as! AddIconTableViewController
            let choosedIconName = source.choosedIconName
            iconName = choosedIconName
        default:
            let error = NSError(domain: "AddFoodTableViewControllerError", code: 2, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)
        }
    }
    
    @IBAction func unwindToAddUserFoodFromReader(segue: UIStoryboardSegue) {
        switch (segue.identifier ?? "") {
        case "AddCodeToNewFood":
            let source = segue.source as! ReadQRViewController
            if !source.qrCodeMessage.isEmpty {
                qrCode = source.qrCodeMessage
            }
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
        if let modifiedFood = modifiedUserFood {
            prepareScreenForModifications(with: modifiedFood)
            isModifing = true
        }
        iconImageView.image = UIImage(named: iconName)
        if let _ = qrCode {
            qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.Added]
            qrCodeAddedLabel.textColor = grassGreen
        } else {
            qrCodeAddedLabel.text = qrCodeLabelStatusMessage[.NotAdded]
            qrCodeAddedLabel.textColor = peachTint
        }
        navigationItem.title = headerOfScreen[isModifing]!
        addFoodButton.isEnabled = checkIfAddingAvailable()
        addDoneButtonToNumKeyboard()
        foodNameField.becomeFirstResponder()
    }
    
    private func prepareScreenForModifications(with modifiedFood: AddedUserFood) {
        foodNameField.text = modifiedFood.name
        let shelfLifeInDays = Int(modifiedFood.shelfLife/secondsInDay)
        shelfLifeField.text = String(shelfLifeInDays)
        iconName = modifiedFood.iconName
        qrCode = modifiedFood.qrCode
    }
    
    private func setBackgroundView() {
        tableView.backgroundView = generateBackgroundImageView()
    }
    
    private func addDoneButtonToNumKeyboard() {
        let toolbarSize = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44)
        let doneToolbar = UIToolbar(frame: toolbarSize)
        doneToolbar.barStyle = .default
        var barButtons = [UIBarButtonItem]()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        barButtons.append(flexSpace)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeKeyboard))
        barButtons.append(doneButton)
        doneToolbar.items = barButtons
        doneToolbar.sizeToFit()
        
        shelfLifeField.inputAccessoryView = doneToolbar
    }
    
    func checkIfAddingAvailable() -> Bool {
        guard let foodName = foodNameField.text else { return false }
        guard !foodName.isEmpty else {
            return false
        }
        
        guard let foodShelfLife = shelfLifeField.text else { return false }
        guard !foodShelfLife.isEmpty else {
            return false
        }
        guard let foodShelfLifeIntoDouble = Double(foodShelfLife) else { return false }
        guard foodShelfLifeIntoDouble > 0 else {
            return false
        }
        return true
    }
    
    func checkIfAddingAvailableWhileEditingData(from textField: UITextField, with string: NSString) -> Bool {
        var unmuttedTextField: UITextField
        if textField === foodNameField {
            unmuttedTextField = shelfLifeField
        } else {
            unmuttedTextField = foodNameField
        }
        guard let unmuttedText = unmuttedTextField.text else { return false }
        guard (unmuttedText as NSString).length > 0 else {
            return false
        }
        guard string.length > 0 else {
            return false
        }

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
        let newInfo =  createNewUserFood()
        dataSource.modifyUserCreatedFood(userModifiedFood, withInfo: newInfo)
        delegate.addOrChangeFood(self, successfully: true)
    }
    
    func createNewUserFood() -> AddedUserFood {
        let name = foodNameField.text!
        let shelfLifeString = shelfLifeField.text!
        let shelfLife = Double(shelfLifeString)! * secondsInDay
        let choosedIconName = iconName
        let choosedCode = qrCode
        
        let createdFood = AddedUserFood()
        createdFood.name = name
        createdFood.foodType = choosedFoodType
        createdFood.iconName = choosedIconName
        createdFood.shelfLife = shelfLife
        createdFood.qrCode = choosedCode
        
        return createdFood
    }
    
    func closeKeyboard() {
        foodNameField.resignFirstResponder()
        shelfLifeField.resignFirstResponder()
        if let tapRecogniser = closeKeyboardTouchRecognizer {
            view.removeGestureRecognizer(tapRecogniser)
        }
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
        case "СhooseIcon":
            break
        case "AddCodeToFood":
            let destinationNC = segue.destination as! UINavigationController
            let destination = destinationNC.viewControllers[0] as! ReadQRViewController
            destination.fromAdd = true
            
        default:
            let error = NSError(domain: "AddFoodTableSegueError", code: 1, userInfo: ["SegueIdentifier":segue.identifier ?? "nil"])
            record(error: error)
        }
    }
    

}

extension AddFoodTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addFoodButton.isEnabled = checkIfAddingAvailable()
        guard let tapRecognizer = closeKeyboardTouchRecognizer else { return true }
        self.view.removeGestureRecognizer(tapRecognizer)
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        closeKeyboardTouchRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        closeKeyboardTouchRecognizer?.cancelsTouchesInView = true
        self.view.addGestureRecognizer(closeKeyboardTouchRecognizer!)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldTextString = textField.text else {
            return true
        }
        let oldText = oldTextString as NSString
        let newString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > 0 {
           addFoodButton.isEnabled = checkIfAddingAvailableWhileEditingData(from: textField, with: newString)
        } else {
           addFoodButton.isEnabled = false
        }
        return true
    }
}
