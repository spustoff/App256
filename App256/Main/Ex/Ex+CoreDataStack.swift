//
//  Ex+CoreDataStack.swift
//  App256
//
//  Created by Вячеслав on 11/15/23.
//

import SwiftUI
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()

    private init() {}

    var modelName: String = "" {
        
        didSet {
            
            persistentContainer = NSPersistentContainer(name: modelName)
            persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        }
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            
            do {
                
                try context.save()
                
            } catch {
                
                let nserror = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
