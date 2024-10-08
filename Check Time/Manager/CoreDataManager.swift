//
//  CoreDataManager.swift
//  Check Time
//
//  Created by Dang Luan on 2024/09/19.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        // pass the data model filename to NSPersistentContainer initializer
        persistentContainer = NSPersistentContainer(name: "Check_Time")
      
        // load any persistent stores
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
    }
    
    // save the changes on your context to the persistent store
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
}
