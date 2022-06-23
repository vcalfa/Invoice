//
//  LocalStorage.swift
//  Invoice
//
//  Created by Vladimir Calfa on 19/06/2022.
//

import Foundation
import CoreData

class LocalStorage {
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MainModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                // Dangerous!!!! on any CoreData initialization error we delete
                // the datastore with data and trying to initialize the CoreData stack again
                
                let storeCoordinator = container.persistentStoreCoordinator
                
                if let persistentStore = storeCoordinator.persistentStores.first,
                   
                    let url = persistentStore.url {
                    if #available(iOS 15.0, *) {
                        let type = NSPersistentStore.StoreType(rawValue: persistentStore.type)
                        try? storeCoordinator.destroyPersistentStore(at: url, type: type, options: nil)
                    } else {
                        try? storeCoordinator.destroyPersistentStore(at: url, ofType: persistentStore.type, options: nil)
                    }
                    
                    container.loadPersistentStores { (storeDescription, error) in
                        if let error = error as NSError? {
                            fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                    }
                }
                
                
                
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


extension LocalStorage: LocalStoreProtocol {
    
    var getContext: NSManagedObjectContext? {
        persistentContainer.viewContext
    }
        
    func fetchAllInvoices() -> [Invoice]? {
        return try? getContext?.fetch(Invoice.fetchRequest())
    }
    
    func fetch(invoiceId: UUID?) -> Invoice? {
        guard let invoiceId = invoiceId,
              let managedContext = getContext else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<Invoice>(entityName: "Invoice")
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(Invoice.invoiceId), invoiceId as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let result: [Invoice]? = try managedContext.fetch(fetchRequest)
            return result?.first
        } catch let error as NSError {
           dump("Retrieving Invoice failed. \(error): \(error.userInfo)")
           return nil
        }
    }
}
