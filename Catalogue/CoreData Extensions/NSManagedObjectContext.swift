//
//  NSManagedObjectContext.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-24.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import CoreData

extension NSManagedObjectContext {
    func persist(block: @escaping () -> Void) {
        perform {
            block()
            
            do {
                try self.save()
            } catch {
                self.rollback()
            }
        }
    }
}
