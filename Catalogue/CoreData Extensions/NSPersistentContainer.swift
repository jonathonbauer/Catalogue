//
//  NSPersistentContainer.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-24.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import CoreData

extension NSPersistentContainer {
    func saveContextIfNeeded() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Error saving data \(nserror)")
            }
        }
    }
}
