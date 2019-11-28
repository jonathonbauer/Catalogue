//
//  LogInVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

class LogInVC: UIViewController {
    
    // MARK: Properties
    var db: DBHelper?
    var settings: UserSettings?
    
    // MARK: Outlets
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var logInAsGuestButton: UIButton!
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Persistent Container if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        //        settings = db?.getSettings()
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the textView's delegates
        username.delegate = self
        password.delegate = self
        
        // Set the Information for the Navigation Item
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Log In"
        
    }
    
    // MARK: View Will Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        
        if db?.getSettings() != nil {
            if db!.getSettings().bypassLogin {
                db!.getSettings().isGuest = true
                print("bypassing login")
                performSegue(withIdentifier: "logInSegue", sender: self)
            }
        }
    }
    
    
    // MARK: Exit Segue
    // Exit Segue for the log out button on the settings page
    @IBAction func logOutSegue(segue: UIStoryboardSegue) {
        db?.getSettings().bypassLogin = false
        db?.getSettings().isGuest = true
    }
    
    // MARK: Log In
    @IBAction func logInButton(_ sender: Any) {
        
        if(username?.text == "admin" && password?.text == db?.getSettings().password) {
            guard let db = db else { return }
            
            db.getSettings().isGuest = false
            db.save()
            
            performSegue(withIdentifier: "logInSegue", sender: self)
        } else {
            // Display an alert to notify of invalid login
            let alert = UIAlertController(title: "Invalid Input", message: "You have entered an invalid username or password.", preferredStyle: .alert)
            
            let reset = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(reset)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    // MARK: Log In As Guest
    @IBAction func logInAsGuestButton(_ sender: Any) {
        guard let db = db else { return }
        db.getSettings().isGuest = true
        db.save()
        performSegue(withIdentifier: "logInSegue", sender: self)
    }
    
    
    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "logInSegue" {
//            if db!.getSettings().isGuest {
//                let backItem = UIBarButtonItem()
//                backItem.title = "Log Out"
//                navigationItem.backBarButtonItem = backItem
//            }
//        }
        if segue.identifier == "logInSegue" {
            print("Preparing")
//            segue.destination.viewControllers!.g
            let destination = segue.destination as! UITabBarController
            let nc = destination.viewControllers![0] as! UINavigationController
            let vc = nc.viewControllers[0] as! InventoryVC
            vc.prepareForGuest()
        }
    }
    
    // MARK: Dismiss Keyboard
    @objc func dismissKeyboard() {
        print("Dismissing keyboard")
        view.endEditing(true)
    }
    
}

// MARK: Text Field Extensions

extension LogInVC:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
