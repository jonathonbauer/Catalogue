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
    
    
    // MARK: Item Functions
    
    func addItem(name: String, price: Double, details: String, category: Category?) -> Bool {
        
        let moc = self.container.viewContext
        
        moc.persist {
            let newItem = Item(context: moc)
            newItem.name = name
            newItem.price = price
            newItem.details = details
            guard let category = category else { return }
            newItem.category = category
            print("Saving item!")
        }
        
        return true
    }
    
    
    func getAllItems() -> [Item] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var items = [NSManagedObject]()
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(items.count) items")
        return items as! [Item]
    }
    
    func getAllItemsForCategory(category: Category) -> [Item] {
        // Get the database and create a request
        let moc = self.container.viewContext
        var items = [NSManagedObject]()
        
        let itemRequest = NSFetchRequest<Item>(entityName: "Item")
        itemRequest.predicate = NSPredicate(format: "category == %@", category)
        
        itemRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            items = try moc.fetch(itemRequest)
        } catch {
            fatalError("Could not load items")
        }
        print("Fetched \(items.count) items with the category \(String(describing: category.name))")
        return items as! [Item]
        
    }
    
    
    // MARK: Category Functions
    
    func addCategory(name: String, details: String) -> Bool {
        
        let moc = self.container.viewContext
        
        moc.persist {
            let newCategory = Category(context: moc)
            newCategory.name = name
            newCategory.details = details
            print("Saving Category!")
        }
        
        return true
    }
    
    func getAllCategories() -> [Category] {
          // Get the database and create a request
        let moc = self.container.viewContext
          var categories = [NSManagedObject]()
          
          let categoryRequest = NSFetchRequest<Category>(entityName: "Category")
          
          categoryRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
          
          do {
              categories = try moc.fetch(categoryRequest)
          } catch {
              fatalError("Could not load items")
          }
          print("Fetched \(categories.count) categories")
          return categories as! [Category]
      }
    
    
    
    
}
