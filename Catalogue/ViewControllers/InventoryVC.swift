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
    
    private let reuseIdentifier = "inventoryCell"
    private var navItem: UINavigationItem?
    
    var container: NSPersistentContainer!
    var items = [NSManagedObject]()
    var categories = [NSManagedObject]()
    
    // MARK: Outlets
    
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
            
//            navVC.pushViewController(newVC!, animated: true)
            navVC.present(newVC!, animated: true, completion: nil)
            
            
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(itemButton)
        alertController.addAction(categoryButton)
        alertController.addAction(cancelButton)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
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
        
//        self.navItem = self.tabBarController?.navigationItem
//        self.navItem?.title = "Inventory"
//        self.navItem?.hidesBackButton = true
//        self.navItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        
        
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
//    @objc func add(){
//
//        // Create the alert controller
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//        // Create the three buttons for the controller
//        let itemButton = UIAlertAction(title: "New Item", style: .default) { _ in
//            self.performSegue(withIdentifier: "itemDetailSegue", sender: self)
//        }
//
//        let categoryButton = UIAlertAction(title: "New Category", style: .default) { _ in
//            self.performSegue(withIdentifier: "categoryDetailSegue", sender: self)
//        }
//
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
//
//        alertController.addAction(itemButton)
//        alertController.addAction(categoryButton)
//        alertController.addAction(cancelButton)
//
//        // Present the controller
//        self.present(alertController, animated: true, completion: nil)
//    }


}
