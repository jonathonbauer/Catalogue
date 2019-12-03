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
    var alertHelper = AlertHelper()
    
    // MARK: Outlets
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
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Set the textView's delegates
        password.delegate = self
        
        // Customise the textView
        password.layer.borderWidth = 1
        password.layer.cornerRadius = 5
        password.layer.borderColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue: 61.0/255.0, alpha: 1.0).cgColor
        
        // Set the Information for the Navigation Item
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Log In"
        
        
        
        
    }
    
    // MARK: View Did Appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
        if db?.getSettings() != nil {
            if db!.getSettings().bypassLogin {
                db!.getSettings().isGuest = true
                print("bypassing login")
                performSegue(withIdentifier: "logInSegue", sender: self)
            }
        }
        
//        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.autoreverse, .repeat], animations:{ ()
//            self.logo.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
////            self.logo.transform = CGAffineTransform(rotationAngle: (720))
//        }, completion: nil)
    }
    
    
    // MARK: Exit Segue
    // Exit Segue for the log out button on the settings page
    @IBAction func logOutSegue(segue: UIStoryboardSegue) {
        db?.getSettings().bypassLogin = false
        db?.getSettings().isGuest = true
    }
    
    // MARK: Log In
    @IBAction func logInButton(_ sender: Any) {
        
        if(password?.text == db?.getSettings().password) {
            guard let db = db else { return }
            
            password?.text = ""
            
            db.getSettings().isGuest = false
            db.logEvent(event: .AdminLogin, details: "Admin has logged in.")
            db.save()
            
            
            performSegue(withIdentifier: "logInSegue", sender: self)
        } else {
            // Display an alert to notify of invalid login
            
            alertHelper.displayAlert(viewController: self, title: "Invalid Input", message: "You have entered an invalid pin.")
            
        }
    }
    
    // MARK: Log In As Guest
    @IBAction func logInAsGuestButton(_ sender: Any) {
        guard let db = db else { return }
        db.getSettings().isGuest = true
        db.logEvent(event: .GuestLogin, details: "Guest has logged in.")
        db.save()
        performSegue(withIdentifier: "logInSegue", sender: self)
    }
    
    
    // MARK: Prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logInSegue" {
            print("Preparing")
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
