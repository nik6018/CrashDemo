//
//  CoreDataManager.swift
//  CDProgressiveMigrationDemo
//
//  Created by Luffy on 05/05/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private let storeType: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CDPM")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.shouldInferMappingModelAutomatically = false //inferred mapping will be handled else where
        description?.shouldMigrateStoreAutomatically = false
        description?.type = storeType
        
        return persistentContainer
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        
        return context
    }()
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    // MARK: - Init
    
    init(storeType: String = NSSQLiteStoreType) {
        self.storeType = storeType
    }
    
    deinit {
        print("Deinit CoreDataManager")
    }
    
    // MARK: - SetUp
    
    func setup(completion: @escaping () -> Void) {
        loadPersistentStore {
            completion()
        }
    }
    
    // MARK: - Loading
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        print("Trying to load the persistent Store")
        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                print("Failed to load persistent store")
                fatalError("was unable to load store \(error!)")
            }
            
            completion()
        }
    }
}


