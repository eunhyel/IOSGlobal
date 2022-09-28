//
//  CoordInfoCd+CoreDataProperties.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/28.
//
//

import Foundation
import CoreData


extension CoordInfoCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoordInfoCd> {
        return NSFetchRequest<CoordInfoCd>(entityName: "CoordInfoCd")
    }

    @NSManaged public var lat: Float
    @NSManaged public var lon: Float
    @NSManaged public var timezone: String?
    @NSManaged public var weatherCd: WeatherCd?

}

extension CoordInfoCd : Identifiable {

}
