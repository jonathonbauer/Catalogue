//
//  InventoryVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-29.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

class InventoryVC: UIViewController {
    
    // MARK: Properties
    var db: DBHelper!
    var inventory = [Category: [Item]]()
    var categories = [Category]()
    var section: Int?
    var headers = [String: Int]()
    var numberFormatter = Formatter(minDecimalPlaces: 2, maxDecimalPlaces: 2)
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var logOut: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set the CollectionView datasource and delegate to this class
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        // MARK: Retrieve the database contents
        loadInventory()
    
    }
    
    // MARK: Prepare
    
    func prepareForGuest(){
        print("We are logging in")
        // Customise the view based on if we are a guest
        guard let tabBarController = tabBarController else {
            print("Returning")
            return
        }
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        if db.getSettings().isGuest {
            print("We're a guest")
            self.navItem?.hidesBackButton = false
            self.navItem?.rightBarButtonItem = nil
            
            tabBarController.viewControllers?.remove(at: 2)
            tabBarController.viewControllers?.remove(at: 1)
        } else {
            print("We're an admin")
            self.navItem?.hidesBackButton = false
            self.navItem?.rightBarButtonItem = addButton
            
            guard let settingsVC = self.storyboard?.instantiateViewController(identifier: "SettingsVC"), let logVC = self.storyboard?.instantiateViewController(identifier: "LogVC"), tabBarController.viewControllers!.count < 3 else { return }
            
            tabBarController.viewControllers?.append(logVC)
            tabBarController.viewControllers?.append(settingsVC)
        }
    }
    
    // MARK: Actions
    
    @IBAction func addItem(_ sender: Any?) {
        print("Add Item Pressed")
        
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the three buttons for the controller
        let itemButton = UIAlertAction(title: "New Item", style: .default) { _ in
            
            guard let navVC = self.navigationController else { return }
            
            let newVC: ItemDetailVC? = self.storyboard?.instantiateViewController(identifier: "ItemDetailVC")
            newVC?.previousVC = self
            
            navVC.present(newVC!, animated: true, completion: nil)
            
        }
        
        let categoryButton = UIAlertAction(title: "New Category", style: .default) { _ in
            
            guard let navVC = self.navigationController else { return }
            
            let newVC: CategoryDetailVC? = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC")
            newVC?.previousVC = self
            navVC.present(newVC!, animated: true, completion: nil)
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(itemButton)
        alertController.addAction(categoryButton)
        alertController.addAction(cancelButton)
        
        // Set the anchor if this is launched on iPad
        alertController.popoverPresentationController?.barButtonItem = self.addButton
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender: Any?) {
        
    }
    
    // MARK: Functions
    
    func loadInventory(){
        // Get all the categories
        categories = db.getAllCategories()
        
        // Get the inventory of items for each category, store it in the dictionary
        if(categories.count != 0) {
            for category in categories {
                inventory[category] = db.getAllItemsForCategory(category: category)
            }
        }
        
        self.collectionView.reloadData()
    }
}


// MARK: Extensions


// MARK: CollectionView DataSource


extension InventoryVC: UICollectionViewDataSource {
    
    //     User selecting the header function
    @objc func categoryTapped(_ sender: CategoryTapGesture){
        
        guard let navVC = self.navigationController else { return }
        
        let newVC: CategoryDetailVC? = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC")
        newVC?.category = categories[sender.indexPath!.section]
        newVC?.previousVC = self
        
        navVC.present(newVC!, animated: true, completion: nil)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventory[categories[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        cell.layer.borderWidth = 1
        
        let item = inventory[categories[indexPath.section]]![indexPath.row]
        
        cell.name?.text = item.name
        cell.price?.text = "$\(numberFormatter.format.string(from: NSNumber(value: (item.value(forKey: "price") as! Double))) ?? "0.00")"
        
        
        if(item.soldOut) {
            cell.soldOut?.text = "Sold Out"
        } else {
            cell.soldOut?.text = "In Stock"
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as! CategoryHeader
        
        // Get the current category
        let category = categories[indexPath.section]
        
        headers[category.name!] = indexPath.section
        
        // Customize the view of the header
        header.name?.text = category.name
        header.layer.cornerRadius = 5
        
        // Detect if a user selects the category
        let tap = CategoryTapGesture(target: self, action: #selector(categoryTapped(_:)))
        tap.indexPath = indexPath
        header.addGestureRecognizer(tap)
        return header
    }
}

// MARK: CollectionView Delegate

extension InventoryVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        guard let navVC = self.navigationController else { return }
        
        let newVC: ItemDetailVC? = self.storyboard?.instantiateViewController(identifier: "ItemDetailVC")
        newVC?.item = inventory[categories[indexPath.section]]![indexPath.row]
        newVC?.previousVC = self
        
        navVC.present(newVC!, animated: true, completion: nil)
    }
}
