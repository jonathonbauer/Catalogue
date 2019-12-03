//
//  SettingsVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: Properties
    private var navItem: UINavigationItem?
    var db: DBHelper!
    var settings: UserSettings?
    var alertHelper = AlertHelper()
    
    
    // MARK: Outlets
    @IBOutlet weak var bypassLogin: UISwitch!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var logOut: UIBarButtonItem!
    
    // MARK: Clear Data
    @IBAction func clearData(_ sender: Any) {
        
        let alert = UIAlertController(title: "Clear All Data", message: "Are you sure you want to clear all data?", preferredStyle: .alert)
        
        let clearData = UIAlertAction(title: "Clear Data", style: .destructive, handler: { _ in
            let secondAlert = UIAlertController(title: "Are You Sure?", message: "Are you absolutely sure you want to clear all data?", preferredStyle: .alert)
            
            let secondClearData = UIAlertAction(title: "Destroy All Data", style: .destructive, handler: { _ in
                // Clear All Data
                self.db.clearDatabase()
                self.db.preloadData()
                print("Data cleared")
            })
            
            let secondCancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            secondAlert.addAction(secondClearData)
            secondAlert.addAction(secondCancel)
            
            self.present(secondAlert, animated: true, completion: nil)
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(clearData)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func bypassLoginSwitch(_ sender: Any) {
        settings?.bypassLogin = bypassLogin.isOn
        db.save()
    }
    
    // MARK: Reset Password
    @IBAction func resetPassword(_ sender: Any) {
        
        guard let password = newPassword.text else {
            alertHelper.displayAlert(viewController: self, title: "Invalid Input", message: "You have not entered a valid pin.")
            return
        }
        
        if(password == confirmPassword.text && password.count >= 4) {
            let confirmReset = UIAlertController(title: "Are you sure?", message: "Are you sure you want to reset your pin?", preferredStyle: .alert)
            
            let reset = UIAlertAction(title: "Reset", style: .default, handler: { _ in
                self.settings?.password = self.newPassword.text
                self.db.save()
                
                self.dismissKeyboard()
                let success = UIAlertController(title: "Pin Updated", message: nil, preferredStyle: .alert)
                let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
                
                success.addAction(okay)
                
                self.present(success, animated: true, completion: nil)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            confirmReset.addAction(cancel)
            confirmReset.addAction(reset)
            
            self.present(confirmReset, animated: true, completion: nil)
            
            
        } else {
            
            alertHelper.displayAlert(viewController: self, title: "Invalid Input", message: "The pins entered do not match or are less than 4 numbers long.")
            
        }
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the nav and tab bar colours
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Avenir", size: 24)!]
        logOut.setTitleTextAttributes([.font: UIFont(name: "Avenir", size: 18)!], for: .normal)
        
        // Customise the textViews
        newPassword.layer.borderWidth = 1
        newPassword.layer.cornerRadius = 5
        newPassword.layer.borderColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        
        confirmPassword.layer.borderWidth = 1
        confirmPassword.layer.cornerRadius = 5
        confirmPassword.layer.borderColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        
        // Get the NavigationItem from the View
        self.navItem = self.tabBarController?.navigationItem
    }
    
    // MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // When the view Appears on the screen, set the title and hide the back button
        self.navItem?.title = "Settings"
        self.navItem?.hidesBackButton = true
        
        // Get the settings from the database
        settings = db.getSettings()
        
        bypassLogin.isOn = settings!.bypassLogin
        
    }
    
    // MARK: viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
    }
    
    // MARK: Dismiss Keyboard
    
    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        print("Dismissing keyboard")
        view.endEditing(true)
    }
}


// MARK: TextView Extensions

extension SettingsVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}
