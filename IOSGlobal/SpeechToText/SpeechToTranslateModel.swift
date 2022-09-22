//
//  SpeechToTranslateModel.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/21.
//

import Foundation
import RxSwift
import RxCocoa


class SpeechToTranslateModel {
    let translateAPIKey = "AIzaSyArN3G4XYRSCgg74ybl426a1S_bfjQ6k7k"
    var isRecording: BehaviorRelay<Bool> = .init(value: false)
    
    var speechSourceText: BehaviorRelay<String> = .init(value: "")
    var translatedText: BehaviorRelay<String> = .init(value: "")
    
}

// MARK: Decodable From API
// Detect Language
struct DetectResponse: Decodable {
    var data: DetectLanguageResponseList
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
}

struct DetectLanguageResponseList: Decodable {
    var detections: [[Detection]]
    
    enum CodingKeys: String, CodingKey {
        case detections
    }
}

struct Detection: Decodable {
    var language: String
    var isReliable: Bool
    var confidence: Float
    
    enum CodingKeys: String, CodingKey {
        case language
        case isReliable
        case confidence
    }
}

// Translate Language
struct TranslateResponse: Decodable {
    var data: TranslateTextResponseList
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct TranslateTextResponseList: Decodable {
    var translations: [TranslateTextResponseTranslation]
    
    enum CodingKeys: String, CodingKey {
        case translations
    }
}

struct TranslateTextResponseTranslation: Decodable {
    var detectedSourceLanguage: String
    var model: String?
    var translatedText: String
    
    enum CodingKeys: String, CodingKey {
        case detectedSourceLanguage
        case model
        case translatedText
    }
}
