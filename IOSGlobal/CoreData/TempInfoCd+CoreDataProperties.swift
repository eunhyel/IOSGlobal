//
//  TempInfoCd+CoreDataProperties.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/27.
//
//

import Foundation
import CoreData


extension TempInfoCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TempInfoCd> {
        return NSFetchRequest<TempInfoCd>(entityName: "TempInfoCd")
    }

    @NSManaged public var feelsLike: Float
    @NSManaged public var temp: Float
    @NSManaged public var tempMax: Float
    @NSManaged public var tempMin: Float
    @NSManaged public var weatherCd: WeatherCd?

}

extension TempInfoCd : Identifiable {

}
