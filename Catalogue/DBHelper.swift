//
//  DBHelper.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-27.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//
// This class will contain any functionality required for interacting
// with the database
//
//

import UIKit
import CoreData

class DBHelper {
    
    // MARK: Properties
    var container: NSPersistentContainer!
    
    // MARK: Save Function
    
    func save() {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Could not save the changes to the database \(error)")
            }
            print("Database has been saved")
        } else {
            print("Database did not need to be saved")
        }
        
    }
    
    
    // MARK: Add Item
    
    func addItem(name: String, image: Data?, price: Double, details: String, soldOut: Bool, category: Category?, completion: @escaping (() -> Void)) -> Bool {
        
        let moc = self.container.viewContext
        
        moc.persist {
            let newItem = Item(context: moc)
            newItem.name = name
            newItem.price = price
            newItem.details = details
            guard let category = category else { return }
            newItem.category = category
            if let imageData = image {
                newItem.image = imageData
            }
            self.logEvent(event: .ItemAdded, details: "The item \(name) has been added.")
            print("Saving item!")
            completion()
        }
        
        return true
        
    }
    
     // MARK: Get All Items
    
    func getAllItems() -> [Item] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var items = [Item]()
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(items.count) items")
        return items
    }
    
     // MARK: Get All Items For Category
    func getAllItemsForCategory(category: Category) -> [Item] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var items = [Item]()
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        itemRequest.predicate = NSPredicate(format: "category == %@", category)
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(items.count) items with the category \(category.name!)")
        return items
        
    }
    
    // MARK: Delete Item
    
    func deleteItem(item: Item) {
        let moc = self.container.viewContext
        
        do {
            moc.delete(item)
            try moc.save()
        } catch {
            fatalError("Could not delete item")
        }
        self.logEvent(event: .ItemAdded, details: "The item \(String(describing: item.name)) has been deleted.")
    }

    // MARK: Get Percent Sold Out
    func getPercentSoldOut(forItems items: [Item]) -> Double {
        var numSoldOut: Double = 0.0
        
        if(items.count != 0) {
            for item in items {
                if item.soldOut {
                    numSoldOut += 1
                }
            }
            return numSoldOut / Double(items.count) * 100
        } else {
            return 0
        }
        
    }
    
    // MARK: Get Total Value
    func getTotalValue(forItems items: [Item]) -> Double {
        var totalValue: Double = 0.0
        
        if(items.count != 0) {
            for item in items {
                totalValue += item.price
            }
            return totalValue
        } else {
            return 0
        }
    }
    
    
    // MARK: Add Category
    
    func addCategory(name: String, details: String, completion: @escaping (() -> Void)) -> Bool {
        
        let moc = self.container.viewContext
        
        moc.persist {
            let newCategory = Category(context: moc)
            newCategory.name = name
            newCategory.details = details
            print("Saving Category!")
            self.logEvent(event: .CategoryAdded, details: "The category \(name) has been added.")
            completion()
        }
        
        return true
    }
    
    
    // MARK: Get All Categories
    
    func getAllCategories() -> [Category] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var categories = [Category]()
        
        let categoryRequest = NSFetchRequest<Category>(entityName: "Category")
        
        categoryRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            categories = try moc.fetch(categoryRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(categories.count) categories")
        return categories
    }
    
    // MARK: Delete Category
    
    func deleteCategory(category: Category) {
           let moc = self.container.viewContext
           
           do {
               moc.delete(category)
               try moc.save()
           } catch {
               fatalError("Could not delete category")
           }
        self.logEvent(event: .CategoryDeleted, details: "The category \(String(describing: category.name)) has been deleted.")
       }
    
    // MARK: - Log Functions
    func logEvent(event: LogEvent, details: String){
        let moc = self.container.viewContext
        
        moc.persist {
            let newLog = Log(context: moc)
            newLog.details = details
            newLog.event = event.rawValue
            newLog.timestamp = Date()
            
            print("Logging event!")
        }
    }
    
    func getLog() -> [Log] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var log = [Log]()
        
        let logRequest = NSFetchRequest<Log>(entityName: "Log")
        
        logRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            log = try moc.fetch(logRequest)
        } catch {
            fatalError("Could not load the log")
        }
        print("Fetched \(log.count) log items")
        return log
    }
    
    
//    // MARK: Add Event
//    func addEvent(name: String, info: String){
//
//        let moc = self.container.viewContext
//
//        moc.persist {
//            let newEvent = Event(context: moc)
//            newEvent.name = name
//            newEvent.info = info
//            print("Adding event!")
//        }
//    }
//
//    func populateEvents() {
//
//        addEvent(name: "Item Added", info: "A new Item has been added")
//        addEvent(name: "Item Updated", info: "The properties of an Item have been modified.")
//        addEvent(name: "Item Deleted", info: "An Item has been deleted.")
//
//        addEvent(name: "Category Added", info: "A new Category has been added")
//        addEvent(name: "Category Updated", info: "The properties of a Category have been modified.")
//        addEvent(name: "Category Deleted", info: "A Category and all of its Items have been deleted.")
//
//        addEvent(name: "Guest Logged In", info: "A guest has logged in.")
//        addEvent(name: "Admin Logged In", info: "An admin has logged in.")
//
//    }

    func compareItems(left: Item, right: Item) -> String {
        var differences = ""
        
        if left.name != right.name {
            differences += "The name has changed from \(String(describing: left.name)) to \(String(describing: right.name)). "
        }
        
        if left.price != right.price {
            differences += "The price has changed from $\(left.price) to $\(right.price). "
        }
        
        if left.details != right.details {
            differences += "The description has changed from \(String(describing: left.details)) to \(String(describing: right.details)). "
        }
        
        if left.category != right.category {
            differences += "The category has changed from \(String(describing: left.category)) to \(String(describing: right.category)). "
        }
        
        if left.image != right.image {
             differences += "The image has changed."
        }
        
        return differences
    }
    
    
}
