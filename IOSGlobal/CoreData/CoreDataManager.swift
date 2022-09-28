//
//  CoreDataManager.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/26.
//

import Foundation
import CoreData
import CoreLocation

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
    func insertWeather(weather: Weather, _ timezoneIdentifier: String? = nil) -> Bool {
//        let entity = NSEntityDescription.entity(forEntityName: "WeatherCd", in: context)
//        let object = NSManagedObject(entity: entity, insertInto: context)
        let object = NSEntityDescription.insertNewObject(forEntityName: "WeatherCd", into: context)
        
        object.setValue(weather.name, forKey: "name")
        
        let tempInfo = NSEntityDescription.insertNewObject(forEntityName: "TempInfoCd", into: context) as! TempInfoCd
        tempInfo.temp = weather.tempInfo.temp
        tempInfo.feelsLike = weather.tempInfo.feelsLike
        tempInfo.tempMin = weather.tempInfo.tempMin
        tempInfo.tempMax = weather.tempInfo.tempMax
        tempInfo.weatherCd = object as? WeatherCd
        
        let coordInfo = NSEntityDescription.insertNewObject(forEntityName: "CoordInfoCd", into: context) as! CoordInfoCd
        coordInfo.lon = weather.coordInfo.lon
        coordInfo.lat = weather.coordInfo.lat
//        coordInfo.timezone = timezoneIdentifier
        coordInfo.weatherCd = object as? WeatherCd
        
        let weatherInfoCd = NSEntityDescription.insertNewObject(forEntityName: "WeatherInfoCd", into: context) as! WeatherInfoCd
        var setWeatherInfoCd = Set<WeatherInfoCd>()
        
        weather.weatherInfo.forEach { winfo in
            weatherInfoCd.id = Int64(winfo.id)
            weatherInfoCd.main = winfo.main
            weatherInfoCd.desc = winfo.desc
            weatherInfoCd.iconURL = winfo.iconURL
            setWeatherInfoCd.insert(weatherInfoCd)
        }
        _ = NSOrderedSet(set: setWeatherInfoCd)
        weatherInfoCd.weatherCd = object as? WeatherCd
//        (object as? WeatherCd)?.addToWeatherInfo(NSSet(set: setWeatherInfoCd))
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
        
    }
    
    @discardableResult
    func update(object: NSManagedObject, weather: Weather, _ timezoneIdentifier: String? = nil) -> Bool {
        object.setValue(weather.name, forKey: "name")
        
        let tempInfo = NSEntityDescription.insertNewObject(forEntityName: "TempInfoCd", into: context) as! TempInfoCd
        tempInfo.temp = weather.tempInfo.temp
        tempInfo.feelsLike = weather.tempInfo.feelsLike
        tempInfo.tempMin = weather.tempInfo.tempMin
        tempInfo.tempMax = weather.tempInfo.tempMax
        tempInfo.weatherCd = object as? WeatherCd
        
        let coordInfo = NSEntityDescription.insertNewObject(forEntityName: "CoordInfoCd", into: context) as! CoordInfoCd
        coordInfo.lon = weather.coordInfo.lon
        coordInfo.lat = weather.coordInfo.lat
        coordInfo.timezone = timezoneIdentifier
        coordInfo.weatherCd = object as? WeatherCd
        
        let weatherInfoCd = NSEntityDescription.insertNewObject(forEntityName: "WeatherInfoCd", into: context) as! WeatherInfoCd
        var setWeatherInfoCd = Set<WeatherInfoCd>()
        
        weather.weatherInfo.forEach { winfo in
            weatherInfoCd.id = Int64(winfo.id)
            weatherInfoCd.main = winfo.main
            weatherInfoCd.desc = winfo.desc
            weatherInfoCd.iconURL = winfo.iconURL
            setWeatherInfoCd.insert(weatherInfoCd)
        }
        _ = NSOrderedSet(set: setWeatherInfoCd)
        weatherInfoCd.weatherCd = object as? WeatherCd
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
    
    /// fetch -> delete
    @discardableResult
    func delete(object: NSManagedObject) -> Bool {
        context.delete(object)
        do {
            try context.save()
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    func deleteAll<T: NSManagedObject>(request: NSFetchRequest<T>) -> Bool {
        let request: NSFetchRequest<NSFetchRequestResult> = T.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try self.context.execute(delete)
            try self.context.save()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func count<T: NSManagedObject>(request: NSFetchRequest<T>) -> Int? {
        do {
            let count = try self.context.count(for: request)
            return count
        } catch {
            return nil
        }
    }
}
