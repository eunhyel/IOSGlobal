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
    @NSManaged public var weatherInfo: NSSet?

}

// MARK: Generated accessors for weatherInfo
extension WeatherCd {

    @objc(addWeatherInfoObject:)
    @NSManaged public func addToWeatherInfo(_ value: WeatherInfoCd)

    @objc(removeWeatherInfoObject:)
    @NSManaged public func removeFromWeatherInfo(_ value: WeatherInfoCd)

    @objc(addWeatherInfo:)
    @NSManaged public func addToWeatherInfo(_ values: NSSet)

    @objc(removeWeatherInfo:)
    @NSManaged public func removeFromWeatherInfo(_ values: NSSet)

}

extension WeatherCd : Identifiable {

}
