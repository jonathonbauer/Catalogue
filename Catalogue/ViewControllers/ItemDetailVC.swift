//
//  ItemDetailVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController {

    // MARK: Properties
    var container: NSPersistentContainer!
    var item: Item?
    
    
    // Number formatter for formatting price
    let format: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.minimumFractionDigits = 2
        f.maximumFractionDigits = 2
        return f
    }()
    
    
    // MARK: Outlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func deleteItem(_ sender: Any) {
    }
    
    @IBAction func toggleSoldOut(_ sender: Any) {
    }
    
    @IBAction func saveItem(_ sender: Any) {
        
//        let itemToSave = Item()
//        itemToSave.name = name.text
//        itemToSave.price = (price.text as NSString?)?.doubleValue ?? 0.00
//        itemToSave.details = details.text
        
        if item == nil {
            let moc = container.viewContext
//            let item = Item.fe
            
            moc.persist {
                let itemToSave = Item(context: moc)
                itemToSave.name = self.name.text
                itemToSave.price = (self.price.text as NSString?)?.doubleValue ?? 0.00
                itemToSave.details = self.details.text
                print("Saving item!")
            }
        }
        
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if(container == nil) {
            print("container is nil on item detail page")
        }
        // Initialize the managed object context
//        let moc = container.viewContext
        
        // Check if this is an edit or a new item
//        if let itemToEdit = item {
//            name.text = itemToEdit.name
//            price.text = "$\(itemToEdit.price)"
//            details.text = itemToEdit.details
//
//            if itemToEdit.soldOut {
//                // Change the button if it is sold out
//
//            }
//
//        }
        
        // Hide the tool bar and customize the nav bar
        
        
        // Customize the buttons
        stockButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        
        
        // Load the information if it is not a new item
        
        
        
    }
    
    // MARK: Functions
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
