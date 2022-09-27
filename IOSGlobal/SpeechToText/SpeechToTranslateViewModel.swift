//
//  SpeechToTranslateViewModel.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/21.
//

import Foundation
import AVFoundation
import googleapis
import RxSwift
import RxCocoa
import Alamofire



class SpeechToTranslateViewModel {
    
    var sttModel = SpeechToTranslateModel()
    let bag = DisposeBag()
    
    var audioData: NSMutableData!
    var dres: DetectResponse!
    
    struct Inptus {
        
    }
    
    var speechText: Driver<String>
    
    init() {
        
        speechText = sttModel.speechSourceText
            .map { $0 }
            .asDriver(onErrorRecover: { _ in .empty() })
        
        sttModel.isRecording
            .bind { [weak self] value in
                guard let self = self else { return }
                self.recordAction()
            }
            .disposed(by: bag)
        
        sttModel.speechSourceText
            .distinctUntilChanged()
            .bind { [weak self] txt in
                guard let self = self else { return }
                if txt == "" { return }
                self.transText(text: txt)
            }
            .disposed(by: bag)
        
        
        
            
        
        AudioController.sharedInstance.delegate = self
        
    }
    
    
}
extension SpeechToTranslateViewModel: AudioControllerDelegate {

    func recordAction() {
        if sttModel.isRecording.value {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setCategory(.record)
            audioData = NSMutableData()
            SpeechRecognitionService.startRecognizing()
        } else {
            SpeechRecognitionService.stopRecognizing()
        }
    }

    func processSampleData(_ data: Data) {
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
                                                    * Double(16000) /* samples/second */
                                                    * 2 /* bytes/sample */);
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    completion:
                                                                        { [weak self] (response, error) in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    print("오디오 데이터 가공 에러 :: \(error.localizedDescription)")
                } else if let response = response {
                    var finished = false
                    print(response)
                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                let trans = result.alternativesArray[0] as? SpeechRecognitionAlternative
//                                self.search_TextFiled.text = trans?.transcript
                                self.sttModel.speechSourceText.accept(trans?.transcript ?? "")
                                finished = true
                            }
                        }
                    }
                    //                strongSelf.textView.text = response.description
                    if finished {
                        // self.stopAudio(self)
                        self.sttModel.isRecording.accept(false)
                    }
                }
            })
            self.audioData = NSMutableData()
        }
    }

}

extension SpeechToTranslateViewModel {
    // translate
    
    func transText(text: String) {
        let url = "https://translation.googleapis.com/language/translate/v2"
        let parm: Parameters = [
            "key" : sttModel.translateAPIKey,
            "q" : text,
            "target" : "kr"
        ]
        let header: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier!
        ]
        DispatchQueue.global().async {
            AF.request(url, method: .post, parameters: parm, headers: header)
                .responseString { response in
                    switch response.result {
                    case .success(let str):
                        print(str)
                        do {
                            let decoder = JSONDecoder()
                            let topModel = try decoder.decode(TranslateResponse.self, from: str.data(using: .utf8) ?? Data())
                            print("헤더추가후",topModel.data.translations.first!.translatedText)
                            self.sttModel.translatedText.accept(topModel.data.translations[0].translatedText)
                        } catch {
                            print("DECODING ERROR",error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    func detectLanguage(text: String) {
        let url = "https://translation.googleapis.com/language/translate/v2/detect"
        let param: Parameters = [
            "q" : text,
            "key" : sttModel.translateAPIKey
        ]
        let header: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier!
        ]
        DispatchQueue.global().async {
            AF.request(url, method: .post, parameters: param, headers: header)
                .responseString { response in
                    switch response.result {
                    case .success(let str):
                        //print(str)
                        do {
                            let decoder = JSONDecoder()
                            let topModel = try decoder.decode(DetectResponse.self, from: str.data(using: .utf8) ?? Data())
                            print("헤더추가후2",topModel.data.detections.first!.first!.language)
                        } catch {
                            print("DECODING ERROR2",error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
        }
    }
    
    
    
    
    
    
    func transText(text: String, nation: String = "en", complete: ((String) -> Void)!){
        
        if text == "" { print("값이 비어 있다")}
        
        let url = "https://translation.googleapis.com/language/translate/v2"
        let parm: Parameters = [
            "key" : sttModel.translateAPIKey,
            "q" : text,
            "target" : nation
        ]
        let header: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier!
        ]
        print("번역 언어 \(text)")
        var text = ""
        AF.request(url, method: .post, parameters: parm, headers: header)
            .responseDecodable(of: TransText.self) { response in
                switch response.result {
                case .success(let data):
                    print(data.data.translations.first?.translatedText ?? "")
                    text = data.data.translations.first?.translatedText ?? ""
                    if let completionCallback = complete {
                        completionCallback(text)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let completionCallback = complete {
                        completionCallback(text)
                    }
                }
            }
    }
}


extension String {
    func transText(nation: String = "en", complete: ((String) -> Void)!){
        let sttModel = SpeechToTranslateModel()
        
        let url = "https://translation.googleapis.com/language/translate/v2"
        let parm: Parameters = [
            "key" : sttModel.translateAPIKey,
            "q" : self,
            "target" : nation
        ]
        let header: HTTPHeaders = [
            "X-Ios-Bundle-Identifier" : Bundle.main.bundleIdentifier!
        ]
        
        var text = ""
        AF.request(url, method: .post, parameters: parm, headers: header)
            .responseDecodable(of: TransText.self) { response in
                switch response.result {
                case .success(let data):
                    print(data.data.translations.first?.translatedText ?? "")
                    text = data.data.translations.first?.translatedText ?? ""
                    if let completionCallback = complete {
                        completionCallback(text)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    if let completionCallback = complete {
                        completionCallback(text)
                    }
                }
            }
    }
}
