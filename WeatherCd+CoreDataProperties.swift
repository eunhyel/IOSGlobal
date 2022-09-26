//
//  WeatherCd+CoreDataProperties.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/26.
//
//

import Foundation
import CoreData


extension WeatherCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherCd> {
        return NSFetchRequest<WeatherCd>(entityName: "WeatherCd")
    }

    @NSManaged public var weatherInfoCd: [WeatherInfo]?
    @NSManaged public var tempInfoCd: TempInfo?
    @NSManaged public var coordInfoCd: CoordInfo?
    @NSManaged public var name: String?

}

extension WeatherCd : Identifiable {

}
