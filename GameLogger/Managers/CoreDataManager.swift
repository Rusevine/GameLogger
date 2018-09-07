//
//  CoreDataManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 07/09/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import Foundation
import CoreData

// Class that is in charge of the core data stack

// Not intended to be subclassed
final class CoreDataManager {
    
    // MARK: - Properties
    
    // The only information we give is the name of the data model
    private let modelName: String
    
    // MARK: - Initialisation
    
    // Accepts the name of the data model as an argument
    init(modelName: String) {
        self.modelName = modelName
    }
    
    
    
    // MARK: - Core Data Stack
    
    // We only mark the setter of the managedObjectContext as private because we need to access it
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        
        // M.O.C is associated with main thread
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // All managed object contexts keep a reference to the persistent store coordinator
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        
        // Ask the application bundle for the url of the model
        //The xcdatamodeld file is not present in the application itself. It is compiled into a momd file instead.
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to find data model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data model")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        // Instantiate an instance of the coordinator using the MOM
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        // Add persistent store to persistent store coordinator:
        
        // 1. Construct url of persistent store
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // 2. Store the persistent store in Documents
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        // 3. Adding a persistent store can fail, so we wrap in a do-catch
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
        } catch {
            fatalError("\(error)")
        }
        
        return persistentStoreCoordinator
        
    }()
    
    
    
    
    
}
