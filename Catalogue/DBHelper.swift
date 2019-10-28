////
////  DBHelper.swift
////  Catalogue
////
////  Created by Jonathon Bauer on 2019-10-27.
////  Copyright © 2019 Jonathon Bauer. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//class DBHelper {
//    
//    // MARK: Properties
//    var container: NSPersistentContainer!
//    var itemResultsController: NSFetchedResultsController<Item>?
//    var categoryResultsController: NSFetchedResultsController<Category>?
//    
//    
//    func getAllItems(){
//        // Get the database and create a request
//        let moc = container.viewContext
//        let request = NSFetchRequest<Item>(entityName: "Item")
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        itemResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
//        
//        itemResultsController?.delegate = self
//        
//        do {
//            try itemResultsController?.performFetch()
//        } catch {
//            print("Failed to get database content")
//        }
//    }
//    
//    
//}
