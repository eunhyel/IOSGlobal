//
//  ViewController.swift
//  IOSGlobal
//
//  Created by eunhye on 2022/09/02.
//

import UIKit
import CoreLocation

import GoogleMaps
import GooglePlaces

import RxCocoa
import RxSwift

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var googleMap_view: UIView!
    @IBOutlet weak var search_TextFiled: UITextField!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mainDescriptionLabel: UILabel!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var language_button: UIButton!
    
    @IBOutlet weak var wather_view: UIView!
    
    var locationManager = CLLocationManager()
    var marker = GMSMarker() // 마커 객체 생성
    
    var gooogleMap : GMSMapView!
    var APIKey = "AIzaSyA3TSL23CF_ymQ1qdDnEspt_frPRkb7xgA"
    var weatherInfo : Weather!

    let fetchWeatherData = FetchWeatherData()
    
    var sttViewModel = SpeechToTranslateViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fetchData("Gwangju", false)
        self.tabBarItem.selectedImage = UIImage(named: "map_icon")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        buttonSet()
        
        laungageSet()
        search_TextFiled.delegate = self
        
        locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
        
                GMSServices.provideAPIKey(APIKey) // 발급받은 API 키로 맵 객체 생성
                GMSPlacesClient.provideAPIKey(APIKey)
        
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.startUpdatingLocation()
                    let currentLat = locationManager.location?.coordinate.latitude ?? 0 //위도
                    let currentLng = locationManager.location?.coordinate.longitude ?? 0 //경도
                    
                    let camera = GMSCameraPosition(latitude: currentLat, longitude: currentLng, zoom: 14) //현재 위도, 경도로 카메라를 이동, 줌 레벨(확대되는 정도)는 17로 설정
                    gooogleMap = GMSMapView.map(withFrame: self.view.frame, camera: camera) // mapView 객체 생성
                    gooogleMap.delegate = self
                    googleMap_view.addSubview(gooogleMap) // view에 mapView를 서브뷰로 추가
                    
                    
                    marker.position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng) // 마커의 위치를 현재 위도, 경도로 설정
                    marker.title = "현재 위치" // 마커 터치하면 나오는 말풍선에 표시할 대제목
                    marker.snippet = "나" // 마커 터치하면 나오는 말풍선에 표시할 소제목
                    marker.map = gooogleMap // 마커를 표시할 맵
                    
                    
                }
        
        sttViewModelBind()
    }
    
    func buttonSet(){
        
        language_button.showsMenuAsPrimaryAction = true
        
        let en = UIAction(title: "영어", handler: { _ in AppData.nationCode = .EN ; self.laungageSet() ; print("영어") })
        let kr = UIAction(title: "한국어", handler: { _ in AppData.nationCode = .KR ; self.laungageSet() ; print("한국어") })
        let cn = UIAction(title: "중국어", handler: { _ in AppData.nationCode = .CN ; self.laungageSet() ; print("중국어") })
        let jp = UIAction(title: "일본어", handler: { _ in AppData.nationCode = .JP ; self.laungageSet() ; print("일본어") })
        let es = UIAction(title: "스페인어", handler: { _ in AppData.nationCode = .ES ; self.laungageSet() ; print("스페인어") })
        let fr = UIAction(title: "불어", handler: { _ in AppData.nationCode = .FR ; self.laungageSet() ; print("불어") })
        let tr = UIAction(title: "터키어", handler: { _ in AppData.nationCode = .TR ; self.laungageSet() ; print("터키어") })
        let th = UIAction(title: "태국", handler: { _ in AppData.nationCode = .TH ; self.laungageSet() ; print("태국") })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
        let buttonMenu = UIMenu(title: "언어 선택", children: [en,kr, cn, jp, es, fr, tr, th, cancel])
        language_button.menu = buttonMenu
    }
    
    func laungageSet(){
        " 지역(도시)를 검색해주세요".transText(nation: AppData.nationCode.rawValue, complete: { text in self.search_TextFiled.placeholder = text })
        
        if let weatherInfo = weatherInfo {
            weatherInfo.name.transText(nation: AppData.nationCode.rawValue, complete: { text in self.cityNameLabel.text = text })
            weatherInfo.weatherInfo[0].main.transText(nation: AppData.nationCode.rawValue, complete: { text in self.mainDescriptionLabel.text = text })
            weatherInfo.weatherInfo[0].desc.transText(nation: AppData.nationCode.rawValue, complete: { text in self.subDescriptionLabel.text = text })
            "평균온도".transText(nation: AppData.nationCode.rawValue, complete: { text in self.temperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weatherInfo.tempInfo.temp) + "℃"})
            "체감온도".transText(nation: AppData.nationCode.rawValue, complete: { text in self.feelsLikeLabel.text = text + ":" + self.kelvinToCelsius(kValue: weatherInfo.tempInfo.feelsLike) + "℃"})
            "최고기온".transText(nation: AppData.nationCode.rawValue, complete: { text in self.maxTemperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weatherInfo.tempInfo.tempMax) + "℃"})
            "최저기온".transText(nation: AppData.nationCode.rawValue, complete: { text in self.minTemperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weatherInfo.tempInfo.tempMin) + "℃"})
        }
        
        
        "지도".transText(nation: AppData.nationCode.rawValue, complete: { text in self.tabBarItem.title = text })
        
    }
    
    func fetchData(_ cityName: String, _ move: Bool = true) {
        fetchWeatherData.fetchData(cityName: cityName) { [weak self] weather, error in
            guard let self = self else { return }
            
            guard let weather = weather else {
                if error != nil {
                    self.sttViewModel.sttModel.isRecording.accept(true)
                    self.alertError()
                }
                return
            }
            print(weather)
            
            self.weatherInfo = weather
            self.iconImageView.kf.setImage(with: weather.weatherInfo[0].iconURL)
            weather.name.transText(nation: AppData.nationCode.rawValue, complete: { text in self.cityNameLabel.text = text })
            weather.weatherInfo[0].main.transText(nation: AppData.nationCode.rawValue, complete: { text in self.mainDescriptionLabel.text = text })
            weather.weatherInfo[0].desc.transText(nation: AppData.nationCode.rawValue, complete: { text in self.subDescriptionLabel.text = text })
            "평균온도".transText(nation: AppData.nationCode.rawValue, complete: { text in self.temperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weather.tempInfo.temp) + "℃"})
            "체감온도".transText(nation: AppData.nationCode.rawValue, complete: { text in self.feelsLikeLabel.text = text + ":" + self.kelvinToCelsius(kValue: weather.tempInfo.feelsLike) + "℃"})
            "최고기온".transText(nation: AppData.nationCode.rawValue, complete: { text in self.maxTemperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weather.tempInfo.tempMax) + "℃"})
            "최저기온".transText(nation: AppData.nationCode.rawValue, complete: { text in self.minTemperatureLabel.text = text + ":" + self.kelvinToCelsius(kValue: weather.tempInfo.tempMin) + "℃"})

            if move {
                let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(weather.coordInfo.lat), longitude: CLLocationDegrees(weather.coordInfo.lon))
                self.marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(weather.coordInfo.lat), longitude: CLLocationDegrees(weather.coordInfo.lon)) // 마커의 위치를 현재 위도, 경도로 설정
                let newCamera = GMSCameraPosition.camera(withTarget: position,
                                                         zoom: self.gooogleMap.camera.zoom + 1)
                let update = GMSCameraUpdate.setCamera(newCamera)
                self.gooogleMap.moveCamera(update)
            }
        }
    }
    
    func kelvinToCelsius(kValue: Float) -> String {
        let celsius = kValue - 273.15
        return String(format: "%.0f", celsius)
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "찾을 수 없는 지역입니다", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.sttViewModel.sttModel.isRecording.accept(false)
        })
        present(alertController, animated: true, completion: nil)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        fetchData(textField.text ?? "")
        print("텍스트필드 엔터 누를때",sttViewModel.sttModel.translatedText.value)
        
        //날씨 API는 영어로 요청해야함
        sttViewModel.transText(text: textField.text ?? "", nation: "en", complete: { text in
            self.fetchData(text)     //번역
        })
        //fetchData(sttViewModel.sttModel.translatedText.value)       //음성
        sttViewModel.sttModel.translatedText.accept("")
        textField.text = ""
        wather_view.isHidden = false
        search_TextFiled.resignFirstResponder()
        return true
    }
    
    func sttViewModelBind() {
        sttViewModel.speechText
            .drive { [weak self] txt in
                guard let self = self else { return }
                self.search_TextFiled.text = txt
            }
            .disposed(by: disposeBag)
    }
    
    
    
    
    
    func onTabSelected(isTheSame: Bool) {
            print("Tab1ViewController onTabSelected")
            //do something
        }
}

extension ViewController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("마커 위치 리스트에 추가")
        //weatherInfo
//        sttViewModel.sttModel.weatherCityForList.append(weatherInfo)
        CoreDataManager.shared.insertWeather(weather: weatherInfo)
        let location = CLLocation(latitude: CLLocationDegrees(weatherInfo.coordInfo.lat), longitude: CLLocationDegrees(weatherInfo.coordInfo.lon))
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, err) in
            if let placemark = placemarks?.first {
                print(#function, #line, placemark.timeZone!)
//                print(#function, #line, placemark.country!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = placemark.timeZone!
                dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm"
                let df = dateFormatter.string(from: Date())
                print(#function, #line, df)
            }
        }
//        let today = Date()
//        let timezone = TimeZone.autoupdatingCurrent
//        print(#function, #line, timezone.description)
//        func localizedRepresentation() -> String {
//            let dateFormatter = DateFormatter()
//            dateFormatter.timeZone = timezone
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//            return dateFormatter.string(from: today)
//        }
//        let localizedDate = localizedRepresentation()
//        print(#function, #line, localizedDate)
        return true
    }
}
