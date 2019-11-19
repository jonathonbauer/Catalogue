//
//  LogDetailVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit

class LogDetailVC: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var event: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    // MARK: Properties
    var logItem: Log?
    var dateFormatter = DateFormatter()
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customize the date formatter
        dateFormatter.dateFormat = "MMMM dd, YYYY h:mma"
        
        
        if let logItem = logItem {
            
            
            details.text = logItem.details
            timestamp.text = dateFormatter.string(from: logItem.timestamp!)
            navBar.topItem?.title = dateFormatter.string(from: logItem.timestamp!)
            
            let logEvent = LogEvent(rawValue: logItem.event)
            switch logEvent {
            case .ItemAdded:
                event.text = "Item Added"
            case .ItemUpdated:
                event.text = "Item Updated"
            case .ItemDeleted:
                event.text = "Item Deleted"
            case .CategoryAdded:
                event.text = "Category Added"
            case .CategoryUpdated:
                event.text = "Category Updated"
            case .CategoryDeleted:
                event.text = "Category Deleted"
            case .AdminLogin:
                event.text = "Admin Login"
            case .GuestLogin:
                event.text = "Guest Login"
            case .none:
                event.text = "Unknown Event"
            }
        }
        
    }
    

    
 

}
