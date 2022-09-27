//
//  WeatherCd+CoreDataProperties.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/27.
//
//

import Foundation
import CoreData


extension WeatherCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCd> {
        return NSFetchRequest<WeatherCd>(entityName: "WeatherCd")
    }

    @NSManaged public var name: String?
    @NSManaged public var coordInfo: CoordInfoCd?
    @NSManaged public var tempInfo: TempInfoCd?
    @NSManaged public var weatherInfo: NSOrderedSet?
}

// MARK: Generated accessors for weatherInfo
extension WeatherCd {

    @objc(insertObject:inWeatherInfoAtIndex:)
    @NSManaged public func insertIntoWeatherInfo(_ value: WeatherInfoCd, at idx: Int)

    @objc(removeObjectFromWeatherInfoAtIndex:)
    @NSManaged public func removeFromWeatherInfo(at idx: Int)

    @objc(insertWeatherInfo:atIndexes:)
    @NSManaged public func insertIntoWeatherInfo(_ values: [WeatherInfoCd], at indexes: NSIndexSet)

    @objc(removeWeatherInfoAtIndexes:)
    @NSManaged public func removeFromWeatherInfo(at indexes: NSIndexSet)

    @objc(replaceObjectInWeatherInfoAtIndex:withObject:)
    @NSManaged public func replaceWeatherInfo(at idx: Int, with value: WeatherInfoCd)

    @objc(replaceWeatherInfoAtIndexes:withWeatherInfo:)
    @NSManaged public func replaceWeatherInfo(at indexes: NSIndexSet, with values: [WeatherInfoCd])

    @objc(addWeatherInfoObject:)
    @NSManaged public func addToWeatherInfo(_ value: WeatherInfoCd)

    @objc(removeWeatherInfoObject:)
    @NSManaged public func removeFromWeatherInfo(_ value: WeatherInfoCd)

    @objc(addWeatherInfo:)
    @NSManaged public func addToWeatherInfo(_ values: NSOrderedSet)

    @objc(removeWeatherInfo:)
    @NSManaged public func removeFromWeatherInfo(_ values: NSOrderedSet)

}

extension WeatherCd : Identifiable {

}
