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
    @IBOutlet weak var deleteUserInfoButton: UIButton!
    
    var dataSource: MutableFoodDataSource!
    
    private let buttonCornerRadius:CGFloat = 10
    private let textCornerRadius:CGFloat = 15
    private let aboutAppFileName = NSLocalizedString("about_en", comment: "About app file name, without extension")

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
        prepareButtons()
        prepareDescriptionCell()
    }
    
    private func prepareButtons() {
        deleteUserInfoButton.layer.cornerRadius = buttonCornerRadius
        deleteUserInfoButton.clipsToBounds = true
        deleteUserInfoButton.backgroundColor = peachTint
        deleteUserInfoButton.setTitleColor(UIColor.white, for: .normal)
        
        deleteUserInfoButton.addTarget(self, action: #selector(deleteUserInfo), for: .touchDown)
    }
    
    private func prepareDescriptionCell() {
        descriptionTextView.layer.cornerRadius = textCornerRadius
        descriptionTextView.clipsToBounds = true
        
        prepareDescriptionLogo()
        prepareDescriptionText()
    }
    
    private func prepareDescriptionText() {
        guard let descriptionFilePath = Bundle.main.url(forResource: aboutAppFileName, withExtension: "rtf") else { return }
        do {
            let atributedString: NSAttributedString = try NSAttributedString(url: descriptionFilePath, options: [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType], documentAttributes: nil)
            descriptionTextView.attributedText = atributedString
            descriptionTextView.textColor = grassGreen
        } catch let error as NSError {
            record(error: error)
        }

    }
    
    private func prepareDescriptionLogo() {
        guard let logo = UIImage(named: "AppLogo") else { return }
        logoImageView.image = logo
        logoImageView.clipsToBounds = true
    }
    
    func deleteUserInfo() {
        let deletingAlert = UIAlertController(title: NSLocalizedString("Alert", comment: "Alert title of deleting all user added info"), message: NSLocalizedString("You want to delete all info, that was added.\nAre you sure?", comment: "Alert message of deleting all user added info"), preferredStyle: .alert)
        let cancelDeleting = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action on deleting all user added info"), style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: "Delete action on deleting all user added info"), style: .destructive, handler: {[weak self] action in
            guard let strongSelf = self else {
                return
            }
            strongSelf.dataSource.deleteAllUserInfo()
        })
        
        deletingAlert.addAction(cancelDeleting)
        deletingAlert.addAction(deleteAction)
        
        self.present(deletingAlert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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
