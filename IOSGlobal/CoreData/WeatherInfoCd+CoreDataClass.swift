//
//  WeatherInfoCd+CoreDataClass.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/26.
//
//

import Foundation
import CoreData

@objc(WeatherInfoCd)
public class WeatherInfoCd: NSManagedObject {

}

extension CodingUserInfoKey {
    static let conetext = CodingUserInfoKey(rawValue: "context")
}
enum DecoderConfigurationError: Error {
    case missingMangedObjectContext
}
