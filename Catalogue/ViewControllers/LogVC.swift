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
    @IBOutlet weak var logOut: UIBarButtonItem!
    
    
    // MARK: Properties
    var db: DBHelper!
    var log = [Log]()
    var alertHelper = AlertHelper()
    
    var dateFormatter = DateFormatter()
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the nav and tab bar colours
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.barTintColor = UIColor.init(red: 138.0/255.0, green: 181.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.unselectedItemTintColor = UIColor.init(red: 23.0/255.0, green: 40.0/255.0, blue:61.0/255.0, alpha: 1.0)
        tabBarController?.tabBar.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Avenir", size: 24)!]
        logOut.setTitleTextAttributes([.font: UIFont(name: "Avenir", size: 18)!], for: .normal)
        
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
    
}

// MARK: TableView DataSource

extension LogVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return log.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logItemCell") as! LogCell
        
        let logItem = log[indexPath.row]
        cell.title.text = logItem.details
        
        cell.subtitle.text = dateFormatter.string(from: logItem.timestamp!)
        
        return cell
    }
    
    
}



// MARK: Tableview Delegate

extension LogVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let logItem = log[indexPath.row]
        
        alertHelper.displayAlert(viewController: self, title: "Log Event Details", message: "\(logItem.details!)\n \(dateFormatter.string(from: logItem.timestamp!))")
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
