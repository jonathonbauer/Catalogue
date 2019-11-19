//
//  LogVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-29.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit

class LogVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    // MARK: Properties
    var db: DBHelper!
    var log = [Log]()
    
    var dateFormatter = DateFormatter()
    
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Event Test: \(LogEvent(rawValue: 1)!)")
        
        // customize the date formatter
        dateFormatter.dateFormat = "MMMM dd, YYYY h:mma"
        
        // Set the table view data source and delegate
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    // MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        log = db.getLog()
        tableView.reloadData()
    }
    
    // MARK: Log Item Tapped
    
    @objc func logItemTapped(){
        
    }
    
    
}

// MARK: TableView DataSource

extension LogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logItemCell") as! LogCell
        
        let logItem = log[indexPath.row]
//        let event = LogEvent(rawValue: logItem.event)
        cell.title.text = logItem.details
        
        
//        switch event {
//        case .ItemAdded:
//            cell.title.text = "Item Added"
//        case .ItemUpdated:
//            cell.title.text = "Item Updated"
//        case .ItemDeleted:
//            cell.title.text = "Item Deleted"
//        case .CategoryAdded:
//            cell.title.text = "Category Added"
//        case .CategoryUpdated:
//            cell.title.text = "Category Updated"
//        case .CategoryDeleted:
//            cell.title.text = "Category Deleted"
//        case .AdminLogin:
//            cell.title.text = "Admin Login"
//        case .GuestLogin:
//            cell.title.text = "Guest Login"
//        case .none:
//            cell.title.text = "Unknown Event"
//        }
        
        cell.subtitle.text = dateFormatter.string(from: logItem.timestamp!)
        
        return cell
    }
    
    
}



// MARK: Tableview Delegate

extension LogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navVC = self.navigationController else { return }
        
        let newVC: LogDetailVC? = self.storyboard?.instantiateViewController(identifier: "LogDetailVC")
        newVC?.logItem = log[indexPath.row]
        
        navVC.present(newVC!, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
