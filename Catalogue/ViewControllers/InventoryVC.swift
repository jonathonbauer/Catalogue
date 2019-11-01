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
    private var navItem: UINavigationItem?
    
    var db: DBHelper!
    var inventory = [Category: [Item]]()
    var categories = [Category]()
    var section: Int?
    
    // Number formatter for formatting price
    let format: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: viewDidLoad & viewDidAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        // Set the CollectionView datasource and delegate to this class
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // When the view Appears on the screen, set the title and hide the back button
        self.navItem?.title = "Inventory"
        self.navItem?.hidesBackButton = true
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        // MARK: Retrieve the database contents
        
        // Get all the categories
        categories = db.getAllCategories()
        
        // Get the inventory of items for each category, store it in the dictionary
        for i in 0...categories.count - 1 {
            print("index: \(i)")
            inventory[categories[i]] = db.getAllItemsForCategory(category: categories[i])
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func addItem(_ sender: Any?) {
        print("Add Item Pressed")
        
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the three buttons for the controller
        let itemButton = UIAlertAction(title: "New Item", style: .default) { _ in
            //            self.performSegue(withIdentifier: "itemDetailSegue", sender: self)
            
            guard let navVC = self.navigationController else { return }
            
            let newVC: ItemDetailVC? = self.storyboard?.instantiateViewController(identifier: "ItemDetailVC")
            
            //            navVC.pushViewController(newVC!, animated: true)
            navVC.present(newVC!, animated: true, completion: nil)
            
        }
        
        let categoryButton = UIAlertAction(title: "New Category", style: .default) { _ in
            
            guard let navVC = self.navigationController else { return }
            
            let newVC: CategoryDetailVC? = self.storyboard?.instantiateViewController(identifier: "CategoryDetailVC")
            
            navVC.present(newVC!, animated: true, completion: nil)
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(itemButton)
        alertController.addAction(categoryButton)
        alertController.addAction(cancelButton)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Functions
    
    
}


// MARK: Extensions


// MARK: CollectionView DataSource


extension InventoryVC: UICollectionViewDataSource {
    
    // User selecting the header function
    @objc func categoryTapped(){
        
        print("TAP")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inventory[categories[section]]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCell
        
        cell.layer.borderWidth = 1
        
        print("Section \(indexPath.section)")
        print("Row \(indexPath.row)")
        let item = inventory[categories[indexPath.section]]![indexPath.row]
        
        cell.name?.text = item.name
        cell.price?.text = "$\(self.format.string(from: NSNumber(value: (item.value(forKey: "price") as! Double))) ?? "0.00")"
        
        
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
        
        // Customize the view of the header
        header.name?.text = category.name
        header.layer.cornerRadius = 5
        
        // Detect if a user selects the category
        let tap = UITapGestureRecognizer(target:self, action:#selector(categoryTapped))
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
        
        navVC.present(newVC!, animated: true, completion: nil)
    }
    
    
    
}