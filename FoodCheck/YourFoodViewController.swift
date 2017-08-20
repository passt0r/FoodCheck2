//
//  YourFoodViewController.swift
//  FoodCheck
//
//  Created by Dmytro Pasinchuk on 30.07.17.
//  Copyright © 2017 Dmytro Pasinchuk. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FoodItemCell"

class YourFoodViewController: UICollectionViewController {

    var dataSource: MutableFoodDataSource!
    
    private let emptyMassage = NSLocalizedString("Seems like your fridge is empty. Press \"Add\" to get some food to your fridge", comment: "Massage for empty fridge")
    
    private lazy var messageLabel: UILabel = {
        return generateMassageLabel()
    }()
    
    private func addBackgroundView() {
        guard let backgroundImage = UIImage(named: "Fridge_background") else { return }
        let backgroundView = UIImageView(image: backgroundImage)
        collectionView?.backgroundView = backgroundView
    }
    
    private func checkEmptyFridge() {
        let itemsCount = dataSource.getFoodItemCount()
        if itemsCount == 0 {
        view.addSubview(messageLabel)
        messageLabel.setupMessage(with: emptyMassage)
            
        } else {
            messageLabel.removeFromSuperview()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        addBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkEmptyFridge()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        switch segue.identifier! {
        case "Read_QR":
            let destinationNV = segue.destination as! UINavigationController
            let destination = destinationNV.topViewController as! ReadQRViewController
            destination.dataSource = dataSource
            destination.delegate = self
        default :
            let error = NSError(domain: "YourFoodSegueError", code: 1, userInfo: nil)
            record(error: error)
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else { return 0 }
        return dataSource.getFoodItemCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FoodItemCell
        
        let currentFoodItem = dataSource.getFood(at: indexPath)
        configure(cell: cell, with: currentFoodItem)
        
        return cell
    }
    
    func configure(cell: FoodItemCell, with foodItem: UserFood) {
        let foodIcon = UIImage(named: foodItem.iconName)
        let foodName = foodItem.name
        
        cell.foodName.text = foodName
        
        if let foodIcon = foodIcon {
            cell.foodIcon.image = foodIcon
        } else {
            cell.foodIcon.image = UIImage(named: "fruit")!
        }
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let deletedFood = dataSource.getFood(at: indexPath)
        dataSource.delete(food: deletedFood)
        collectionView.deleteItems(at: [indexPath])
        collectionViewLayout.invalidateLayout()
        checkEmptyFridge()
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension YourFoodViewController: AddFoodToFridgeDelegate {
    func foodAddToFridge(_ source: FoodSearchingController, successfuly added: Bool) {
        if added {
            collectionView?.reloadData()
            dismiss(animated: true, completion: nil)
        } else {
            //dismiss(animated: true, completion: nil)
        }
    }
}
