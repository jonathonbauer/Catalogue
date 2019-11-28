//
//  CategoryDetailVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-29.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

class CategoryDetailVC: UIViewController {
    
    // MARK: Properties
    var category: Category?
    var db: DBHelper!
    var numSoldOut = 0
    var previousVC: UIViewController?
    var isInEditMode = false
    var numberFormatter = Formatter(minDecimalPlaces: 0, maxDecimalPlaces: 2)
    
    // MARK: Outlets
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var percentSoldOut: UILabel!
    @IBOutlet weak var totalValue: UILabel!
    
    // MARK: Delete Category
    @IBAction func deleteCategory(_ sender: Any) {
        guard let category = category else { return }
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this category and all its items?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete Category", style: .destructive, handler: { _ in
            
            self.db.deleteCategory(category: category)
            
            if let previousVC = self.previousVC {
                previousVC.viewWillAppear(true)
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Edit Category
    @IBAction func editCategory(_ sender: Any) {
        if(isInEditMode) {
            let success = saveCategory()
            if (success) {
                setEditMode(enabled: false)
            }
        } else {
            setEditMode(enabled: true)
        }
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate
                else { return }
            db = appDelegate.dbHelper
        }
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the text fields delegates to this view controller
        self.name.delegate = self
        self.details.delegate = self
        
        // Customise the text view
        self.details.layer.cornerRadius = 5
        self.details.layer.borderWidth = 0.5
        self.details.layer.borderColor = UIColor.lightGray.cgColor
        self.details.clipsToBounds = true
        
        self.name.sizeToFit()
        
        setEditMode(enabled: true)
        
        // MARK: Populate Category
        if let category = category {
            self.navBar.topItem?.title = category.name
            self.name.text = category.name
            self.details.text = category.details
            let items = db.getAllItemsForCategory(category: category)
            self.numberOfItems.text = String(items.count)
            self.percentSoldOut.text = "\(numberFormatter.format.string(from: NSNumber(value: db.getPercentSoldOut(forItems: items))) ?? "0") %"
            self.totalValue.text = "$\(numberFormatter.format.string(from: NSNumber(value: db.getTotalValue(forItems: items))) ?? "0.00")"
            setEditMode(enabled: false)
        }
        
    }
    
    // MARK: Dismiss Keyboard
    
    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: Set Edit Mode
    func setEditMode(enabled: Bool) {
        if(enabled) {
            self.editButton.title = "Done"
            self.navBar.topItem?.leftBarButtonItem = self.deleteButton
            self.name.isEnabled = true
            self.details.isEditable = true
            self.isInEditMode = true
        } else {
            self.editButton.title = "Edit"
            self.navBar.topItem?.leftBarButtonItem = nil
            self.name.isEnabled = false
            self.details.isEditable = false
            self.isInEditMode = false
            self.dismissKeyboard()
        }
    }
    
    // MARK: Save Category
    
    func saveCategory() -> Bool {
        // Check that there is valid input
        guard
            let nameInput = self.name.text,
            nameInput.count > 0,
            let detailsInput = self.details.text,
            detailsInput.count > 0
            else {
                print("Invalid input")
                return false
        }
        
        if let category = category {
            let originalName = category.name
            category.name = nameInput
            category.details = detailsInput
            self.navBar.topItem?.title = category.name
            db.save()
            db.logEvent(event: .CategoryUpdated, details: "The category \(originalName!) has been updated")
            if let previousVC = self.previousVC {
                previousVC.viewWillAppear(true)
            }
            return true
        } else {
            
            let success = db.addCategory(name: nameInput, details: detailsInput, completion: {
                print("Successfully added category")
                if let previousVC = self.previousVC {
                    previousVC.viewWillAppear(true)
                }
                self.dismiss(animated: true, completion: nil)
            })
            
            if(!success) {
                print("Could not add category")
                return false
            }
            
        }
        
        return true
    }
    
}

// MARK: Extensions

extension CategoryDetailVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension CategoryDetailVC:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}
