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
    var item: Item?
    var db: DBHelper!
    var categories = [Category]()
    var selectedCategory: Category?
    var picker: UIPickerView?
    var isInEditMode = false
    var previousVC: UIViewController?
    var soldout = false
    
    
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
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    // MARK: Edit Item
    
    @IBAction func editItem(_ sender: Any) {
        if(isInEditMode) {
            let success = saveItem()
            if (success) {
                setEditMode(enabled: false)
            }
        } else {
            setEditMode(enabled: true)
        }
    }
    
    
    // MARK: Delete Item
    @IBAction func deleteItem(_ sender: Any) {
        
        guard let item = item else { return }
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete Item", style: .destructive, handler: { _ in
            self.db.deleteItem(item: item)
            
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
    
    // MARK: Toggle Sold Out
    @IBAction func toggleSoldOut(_ sender: Any) {
        if soldout {
            soldout = false
            stockButton.setTitle("In Stock", for: .normal)
//            stockButton.titleLabel?.text = "In Stock"
        } else {
            soldout = true
            stockButton.setTitle("Sold Out", for: .normal)
//            stockButton.titleLabel?.text = "Sold Out"
        }
    }
    
    // MARK: Save Item
    @IBAction func saveItem(_ sender: Any) {
        let success = saveItem()
        print(success)
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
        
        // Customize the buttons
        stockButton.layer.cornerRadius = 10
        
        // Customize the text fields
        self.details.layer.cornerRadius = 5
        self.details.layer.borderWidth = 0.5
        self.details.layer.borderColor = UIColor.lightGray.cgColor
        self.details.clipsToBounds = true
        
        // Set the title
        self.navBar.topItem?.title = "New Item"
        
        // Create and customise the picker for selecting the category
        picker = UIPickerView()
        
        // Set the inputView of the Category TextField to the picker
        category.inputView = picker
        
        // Assign the delegate and datasource of the picker to this class
        picker?.dataSource = self
        picker?.delegate = self
        
        
        // Customize the view differently if this is a new item or not
        if let item = item {
            // Disable edit mode if this an existing item
            setEditMode(enabled: false)
            
            // Set the Title
            self.navBar.topItem?.title = item.name
            
            self.name.text = item.name
            self.price.text = "\(self.format.string(from: NSNumber(value: item.price)) ?? "0.00")"
            self.details.text = item.details
            self.category.text = item.category?.name
            selectedCategory = item.category
            if item.soldOut {
                self.stockButton.setTitle("Sold Out", for: .normal)
            } else {
                self.stockButton.setTitle("In Stock", for: .normal)
            }
            
        } else {
            // If this is a new item
            setEditMode(enabled: true)
            self.navBar.topItem?.leftBarButtonItem = nil
            self.navBar.topItem?.rightBarButtonItem?.title = "Save Item"
            
        }
  
    }
    
    // MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        categories = db.getAllCategories()
    }
    
    
    // MARK: Dismiss Keyboard
    
    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: Category Selected
    @objc func categorySelected(_ sender: CategoryTapGesture){
        print("Category tapped")
        selectedCategory = categories[sender.row!]
        self.resignFirstResponder()
    }
    
    // MARK: Toggle Edit Mode
    func toggleEditMode(){
        if(!isInEditMode) {
            
        } else {
            let success = saveItem()
            if(success) {
                
            }
        }
    }
    
    // MARK: Set Edit Mode
    func setEditMode(enabled: Bool) {
        if(enabled) {
            self.editButton.title = "Done"
            self.navBar.topItem?.leftBarButtonItem = self.deleteButton
            self.stockButton.isEnabled = true
            self.name.isEnabled = true
            self.price.isEnabled = true
            self.category.isEnabled = true
            self.details.isEditable = true
            self.isInEditMode = true
        } else {
            self.editButton.title = "Edit"
            self.navBar.topItem?.leftBarButtonItem = nil
            self.stockButton.isEnabled = false
            self.name.isEnabled = false
            self.price.isEnabled = false
            self.category.isEnabled = false
            self.details.isEditable = false
            self.isInEditMode = false
            self.dismissKeyboard()
        }
    }
    
    // MARK: Save Item
    
    func saveItem() -> Bool {
        print("Save button pressed")
        // Check that there is valid input
        guard
            let nameInput = self.name.text,
            let priceInput = (self.price.text as NSString?)?.doubleValue,
            let detailsInput = self.details.text,
            let categoryInput = self.selectedCategory
            else {
                print("Invalid input")
                return false
        }
        
        
        if let selectedItem = item {
            selectedItem.name = nameInput
            print("Items price: \(priceInput)")
            selectedItem.price = priceInput
            selectedItem.details = detailsInput
            selectedItem.category = categoryInput
            selectedItem.soldOut = soldout
            db.save()

            if let previousVC = self.previousVC {
                previousVC.viewWillAppear(true)
            }
            return true
//            self.dismiss(animated: true, completion: nil)
            
        } else {
            let success = db.addItem(name: nameInput, price: priceInput, details: detailsInput, soldOut: soldout, category: selectedCategory, completion: {
                print("Successfully added item!")
                
                if let previousVC = self.previousVC {
                    previousVC.viewWillAppear(true)
                }
                self.dismiss(animated: true, completion: nil)
                
            })
            
            if(!success) {
                print("Could not add item")
                return false
            }
            return true
        }
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

extension ItemDetailVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

}

extension ItemDetailVC: UIPickerViewDelegate {
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tap = CategoryTapGesture(target: self, action: #selector(categorySelected(_:)))
        tap.row = row
        pickerView.addGestureRecognizer(tap)
        return categories[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.text = categories[row].name
        selectedCategory = categories[row]
        category.resignFirstResponder()
    }
    
}
