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

//    enum CodingKeys: String, CodingKey {
//        case id
//        case main
//        case desc = "description"
//        case iconURL
//    }
//    required convenience public init(from decoder: Decoder) throws {
//        guard let contextUserInfoKey = CodingUserInfoKey.conetext else { fatalError("cannot find context key") }
//        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError("cannot retrieve context") }
//        guard let entity = NSEntityDescription.entity(forEntityName: "WeatherInfoCd", in: managedObjectContext) else { fatalError() }
//        self.init(entity: entity, insertInto: nil)
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(Int64.self, forKey: .id)
//        self.main = try container.decode(String.self, forKey: .main)
//        self.desc = try container.decode(String.self, forKey: .desc)
//        self.iconURL = try container.decode(URL.self, forKey: .iconURL)
//    }
}

extension CodingUserInfoKey {
    static let conetext = CodingUserInfoKey(rawValue: "context")
}
enum DecoderConfigurationError: Error {
    case missingMangedObjectContext
}
