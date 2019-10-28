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
        
        // Check that there is valid input
        guard
            let nameInput = self.name.text,
            let priceInput = (self.price.text as NSString?)?.doubleValue,
            let detailsInput = self.details.text
        else {
            print("Invalid input")
            return
        }
        
        // If this is a new item, get the details and save it to the database
        if item == nil {
            let moc = container.viewContext
            
            moc.persist {
                let itemToSave = Item(context: moc)
                itemToSave.name = nameInput
                itemToSave.price = priceInput
                itemToSave.details = detailsInput
                print("Saving item!")
            }
        }
        
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the text fields delegates to this view controller
        self.name.delegate = self
        self.price.delegate = self
        self.details.delegate = self
        
        
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
    
    // MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the Persistent Container if it is nil
        if container == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            container = appDelegate.persistentContainer
        }
    }
    
    
    // MARK: Functions

    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}


// MARK: Extensions

extension ItemDetailVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ItemDetailVC:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
