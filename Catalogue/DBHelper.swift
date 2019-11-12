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
    
    
    // MARK: Item Functions
    
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
            
            print("Saving item!")
            completion()
        }
        
        return true
        
    }
    
    
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
    
    func deleteItem(item: Item) {
        let moc = self.container.viewContext
        
        do {
            moc.delete(item)
            try moc.save()
        } catch {
            fatalError("Could not delete item")
        }
    }
    
    func getPercentSoldOut(forItems items: [Item]) -> Int {
        var numSoldOut = 0
        
        if(items.count != 0) {
            for item in items {
                if item.soldOut {
                    numSoldOut += 1
                }
            }
            return numSoldOut / items.count * 100
        } else {
            return 0
        }
        
    }
    
    // MARK: Category Functions
    
    func addCategory(name: String, details: String, completion: @escaping (() -> Void)) -> Bool {
        
        let moc = self.container.viewContext
        
        moc.persist {
            let newCategory = Category(context: moc)
            newCategory.name = name
            newCategory.details = details
            print("Saving Category!")
            completion()
        }
        
        return true
    }
    
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
    
    func deleteCategory(category: Category) {
           let moc = self.container.viewContext
           
           do {
               moc.delete(category)
               try moc.save()
           } catch {
               fatalError("Could not delete category")
           }
       }
    
    
}
