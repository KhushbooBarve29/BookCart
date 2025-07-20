//
//  PersistenceController.swift
//  BookCart
//
//  Created by Khushboo Barve on 18/07/2025.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "BookCartModel")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load Core Data store: \(error)")
            }
        }
    }
}
