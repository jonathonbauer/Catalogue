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
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the Information for the Navigation Item
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Log In"
    }
    

    
     // MARK: - Prepare

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        

    }


}
