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
    private static let name = "TimeBreak_1"
    
    var context: NSManagedObjectContext {
        //return persistentContainer.
    }

    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.name)
        container.load@PersistentStores { storeDescripton, error in
            if let error = error as NSError? {
                print("Error: \(error.userInfo)")
            }
    }
        return container
    }()
}

