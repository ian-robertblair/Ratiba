//
//  Persistence.swift
//  Ratiba
//
//  Created by ian robert blair on 2023/1/6.
//

import Foundation

import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: <#NameOfModel#>)
        persistentContainer.loadPersistentStores { desciption, error in
            if let error = error {
                fatalError("Core Data failed to initialize \(error.localizedDescription)")
            }
        }
    }
    
    func save(<#Attributes#>) {
        let application = Application(context: persistentContainer.viewContext)
        
        application.name = name
        application.type = type
        application.group = group
        
        do {
            try persistentContainer.viewContext.save()
            print("Application saved...")
        } catch {
            print("Failed to save application: \(error.localizedDescription)")
        }
        
    }
    
    func getAll() -> [<#Object#>] {
        let fetchRequest: NSFetchRequest<Application> = Application.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func delete(application: <#Object#>) {
        persistentContainer.viewContext.delete(application)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            persistentContainer.viewContext.rollback()
            print("Failed to save context \(error.localizedDescription)")
        }
    }
    
}

