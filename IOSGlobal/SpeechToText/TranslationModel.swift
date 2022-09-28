//
//  TranslationModel.swift
//  IOSGlobal
//
//  Created by eunhye on 2022/09/27.
//

import Foundation

struct AppData {
    static var nationCode : NationCode = .EN
}

enum NationCode : String{
    case KR = "ko"
    case EN = "en"
    case CN = "zh-CN"
    case JP = "ja"
    case ES = "es"
    case FR = "fr"
    case TR = "tr"
    case TH = "th"
}

struct TransText: Decodable {
    let data: DataInfo

      enum CodingKeys: String, CodingKey {
        case data = "data"
      }
}

struct DataInfo: Decodable {
    let translations: [Translations]
    
    enum CodingKeys: String, CodingKey {
        case translations = "translations"
      }
}


struct Translations: Decodable {
    let translatedText: String
    let detectedSourceLanguage: String
    
    enum CodingKeys: String, CodingKey {
        case translatedText = "translatedText"
        case detectedSourceLanguage = "detectedSourceLanguage"
      }
}
