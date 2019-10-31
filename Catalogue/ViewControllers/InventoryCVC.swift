//
//  InventoryCVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "inventoryCell"

class InventoryCVC: UICollectionViewController {

    // MARK: Properties
    
    private var navItem: UINavigationItem?
    
    var container: NSPersistentContainer!
    var items = [NSManagedObject]()
    var categories = [NSManagedObject]()
    
    // MARK: Outlets
    
    // MARK: Actions
    
    @IBAction func addItem(_ sender: Any?) {
        print("Add Item Pressed")
    }
    
    // MARK: viewDidLoad & viewDidAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Persistent Container if it is nil
        if container == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            container = appDelegate.persistentContainer
        }

        // Get the NavigationItem from the View, set the title and hide the back button
        
        self.navItem = self.tabBarController?.navigationItem
        self.navItem?.title = "Inventory"
        self.navItem?.hidesBackButton = true
        self.navItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        // MARK: Retrieve the database contents
        
        // Get the database and create a request
        let moc = container.viewContext
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        let categoryRequest = NSFetchRequest<Category>(entityName: "Category")
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        categoryRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
            categories = try moc.fetch(categoryRequest)
        } catch {
            fatalError("Could not load items or categories")
        }
        print("Fetched \(items.count) items")
        print("Fetched \(categories.count) items")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // When the view Appears on the screen, set the title and hide the back button
        self.navItem?.title = "Inventory"
        self.navItem?.hidesBackButton = true
        
        // Get the Persistent Container if it is nil
        if container == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            container = appDelegate.persistentContainer
        }
        
    }
    

    // MARK: Functions

    // Add button function
    @objc func add(){
        
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the three buttons for the controller
        let itemButton = UIAlertAction(title: "New Item", style: .default) { _ in
            self.performSegue(withIdentifier: "itemDetailSegue", sender: self)
        }
        
        let categoryButton = UIAlertAction(title: "New Category", style: .default) { _ in
            self.performSegue(withIdentifier: "categoryDetailSegue", sender: self)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(itemButton)
        alertController.addAction(categoryButton)
        alertController.addAction(cancelButton)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    

    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Pass the container to the next view controller
//               if let navVC = segue.destination as? UINavigationController,
//                   let itemVC = navVC.viewControllers[0] as? ItemDetailVC {
////                   itemVC.container = container
//               }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "categoryHeader", for: indexPath) as! CategoryHeader
        
        header.nameButton.setTitle("HEADER", for: .normal)
        
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! InventoryCell
        
        cell.nameLabel?.text = items[indexPath.row].value(forKey: "name") as? String
        
        cell.contentView.backgroundColor = UIColor.yellow
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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

