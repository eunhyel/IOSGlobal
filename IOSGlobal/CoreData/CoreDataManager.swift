//
//  CoreDataManager.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/26.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherCollections")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved Error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    /// let request: NSFetchRequest<Contact> = Contact.fetchRequest()
    /// let fetchResult = CoreDataManager.shared.fetch(request: request) // [Contact]
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try self.context.fetch(request)
            return fetchResult
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    @discardableResult
    func insertWeather(weather: Weather) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "WeatherCd", in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(weather.name, forKey: "name")
            managedObject.setValue(weather.weatherInfo, forKey: "weatherInfoCd")
            managedObject.setValue(weather.tempInfo, forKey: "tempInfoCd")
            managedObject.setValue(weather.coordInfo, forKey: "coordInfoCd")
            
            do {
                try self.context.save()
                return true
            } catch {
                print(error.localizedDescription)
                return false
            }
        } else {
            return false
        }
    }
    
    /// fetch -> delete
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        context.delete(object: object)
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetch: request)
        do {
            try self.context.execute(delete)
            return true
        } catch {
            return false
        }
    }
    
}
