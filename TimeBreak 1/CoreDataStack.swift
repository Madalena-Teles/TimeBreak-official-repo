//
//  CoreDataStack.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 4/25/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    private static let name = "CategoryTaskModel"
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.name)
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                print("Error: \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch  {
                let nserror = error as NSError
                print("Unresolved error: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


