//
//  WeatherInfoCd+CoreDataProperties.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/27.
//
//

import Foundation
import CoreData


extension WeatherInfoCd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherInfoCd> {
        return NSFetchRequest<WeatherInfoCd>(entityName: "WeatherInfoCd")
    }

    @NSManaged public var desc: String?
    @NSManaged public var iconURL: URL?
    @NSManaged public var id: Int64
    @NSManaged public var main: String?
    @NSManaged public var weatherCd: WeatherCd?
    
    public var icon: String {
        get {
            guard let iconURL = iconURL else { return "" }
            let iconStr = iconURL.absoluteString
            let start = iconStr.index(iconStr.startIndex, offsetBy: 34)
            let end = iconStr.index(start, offsetBy: 2)
            let range = start...end
            return String(iconStr[range])
        }
    }
}

extension WeatherInfoCd : Identifiable {

}
