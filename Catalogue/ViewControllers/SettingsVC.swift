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
    var themePicker: UIPickerView?
    var themes = [Theme.System, Theme.Dark, Theme.Light]
    
    
    // MARK: Outlets
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var bypassLogin: UISwitch!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
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
        
        if(newPassword.text == confirmPassword.text) {
            let confirmReset = UIAlertController(title: "Are you sure?", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
            
            let reset = UIAlertAction(title: "Reset", style: .default, handler: { _ in
                self.settings?.password = self.newPassword.text
                self.db.save()
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
            confirmReset.addAction(cancel)
            confirmReset.addAction(reset)
            
            
            self.present(confirmReset, animated: true, completion: nil)
            
            
        } else {
            let invalidPasswordAlert = UIAlertController(title: "Passwords Do Not Match", message: nil, preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            invalidPasswordAlert.addAction(okay)
            
            self.present(invalidPasswordAlert, animated: true, completion: nil)
            
        }
        
        
    }
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Create and add the pickerView
        themePicker = UIPickerView()
        
        // Add a done button to the pickerview
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerSelected))
        
        toolBar.setItems([spacer, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        // Set the inputView of the Category TextField to the picker
        theme.inputView = themePicker
        theme.inputAccessoryView = toolBar
        
        // Assign the delegate and datasource of the picker to this class
        themePicker?.dataSource = self
        themePicker?.delegate = self
        
        
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
        
        if(settings?.theme == 0) {
            theme.text = "System"
            settings?.theme = themes[0].rawValue
        } else if(settings?.theme == 1) {
            theme.text = "Light"
            settings?.theme = themes[1].rawValue
        } else if(settings?.theme == 2) {
            theme.text = "Dark"
            settings?.theme = themes[2].rawValue
        } else {
            theme.text = "Unknown Theme"
        }
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
    
    // MARK: Picker Selected
    @objc func pickerSelected(){
        
        if let row = themePicker?.selectedRow(inComponent: 0) {
            if(row == 0) {
                theme.text = "System"
                settings?.theme = themes[0].rawValue
            } else if(row == 1) {
                theme.text = "Light"
                settings?.theme = themes[1].rawValue
            } else if(row == 2) {
                theme.text = "Dark"
                settings?.theme = themes[2].rawValue
            } else {
                theme.text = "Unknown Theme"
            }
        }
        db.save()
        dismissKeyboard()
        
    }
}


// MARK: TextView Extensions

extension SettingsVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
}


// MARK: PickerView Extensions

extension SettingsVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
}

extension SettingsVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if(row == 0) {
            return "System"
        } else if(row == 1) {
            return "Light"
        } else if(row == 2) {
            return "Dark"
        } else {
            return "Unknown Theme"
        }
        
        
    }
    
}
