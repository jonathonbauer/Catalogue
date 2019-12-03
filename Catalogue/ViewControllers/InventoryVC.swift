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
        
        
        // Customize the nav and tab bar controllers
        navigationController?.navigationBar.tintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
         navigationController?.navigationBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Avenir", size: 24)!]
        logOut.setTitleTextAttributes([.font: UIFont(name: "Avenir", size: 18)!], for: .normal)
        
        
        
        // Set the CollectionView datasource and delegate to this class
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        // Index this page for spotlight
        
        let activity = NSUserActivity(activityType: "ca.catalogue.openTab")
        activity.title = "Inventory"
        activity.isEligibleForSearch = true
        activity.isEligibleForPublicIndexing = true
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
    }
    
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        // MARK: Retrieve the Database
        loadInventory()
    
    }
    
    // MARK: Prepare For Guest
    
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
    
    // MARK: Add Item
    
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
    
    // MARK: Load Inventory
    
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
        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
//        cell.layer.cornerRadius = 5
        
//        cell.layer.shadowColor = UIColor.init(red: 222.0/255.0, green: 222.0/255.0, blue:217.0/255.0, alpha: 1.0).cgColor
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 1.0
        cell.layer.masksToBounds = false
        
        
        let item = inventory[categories[indexPath.section]]![indexPath.row]
        
        cell.name?.text = item.name
        cell.price?.text = "$\(numberFormatter.format.string(from: NSNumber(value: (item.value(forKey: "price") as! Double))) ?? "0.00")"
        
        if let data = item.image {
            cell.imageView.image = UIImage(data: data)
        } else {
            cell.imageView.image = UIImage(named: "inventory")
        }
        
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
//        header.layer.cornerRadius = 5
//        header.layer.borderWidth = 1
//        header.layer.borderColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        
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
