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

    var db: DBHelper!
    var items = [NSManagedObject]()
    var categories = [NSManagedObject]()
    
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
        
        items = db.getAllItems()
        categories = db.getAllCategories()
        
        
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
    
    // MARK: Functions
    
    
    
}
