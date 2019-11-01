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
            //            let newCategory = Category(context: moc)
            let success = db.addItem(name: nameInput, price: priceInput, details: detailsInput, category: selectedCategory)
            
            if(success) {
                print("Successfully added item!")
            } else {
                print("Could not add item")
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
        
        
        // Customize the buttons
        stockButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        
        // Create and customise the picker for selecting the category
        picker = UIPickerView()
        
        // Set the inputView of the Category TextField to the picker
        category.inputView = picker
        
        // Assign the delegate and datasource of the picker to this class
        picker?.dataSource = self
        picker?.delegate = self
        
        
        // Load the information if it is not a new item
        if(item != nil) {
            self.name.text = item?.name
            self.price.text = "$\(self.format.string(from: NSNumber(value: (item?.price ?? 0.00))) ?? "0.00")"
            self.details.text = item?.details
            self.category.text = item?.category?.name
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
        return categories[row].name
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        category.text = categories[row].name
        selectedCategory = categories[row]
        category.resignFirstResponder()
    }
}
