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
    var category: NSManagedObject?
    var db: DBHelper!
    
    // MARK: Outlets
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var numberOfItems: UITextField!
    @IBOutlet weak var percentSoldOut: UITextField!
    
    // MARK: Actions
    @IBAction func deleteCategory(_ sender: Any) {
    }
    
    @IBAction func saveCategory(_ sender: Any) {
        
        // Check that there is valid input
        guard
            let nameInput = self.name.text,
            let detailsInput = self.details.text
        else {
            print("Invalid input")
            return
        }
        
        // Check if this is not a new item
        if category == nil {
            
            let success = db.addCategory(name: nameInput, details: detailsInput)
            
            if(success) {
                print("Successfully added category")
            } else {
                print("Could not add category")
            }
            
        }
        
        
    }
    
    
    // MARK: viewDidLoad and viewWillAppear
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the text fields delegates to this view controller
        self.name.delegate = self
        self.details.delegate = self
        self.numberOfItems.delegate = self
        self.percentSoldOut.delegate = self
        
        // Customize the buttons
        deleteButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
    }
    
    // MARK: Functions

    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
