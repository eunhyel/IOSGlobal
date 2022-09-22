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
    
    @IBOutlet weak var wather_view: UIView!
    
    var locationManager = CLLocationManager()
    
    var gooogleMap : GMSMapView!
    var APIKey = "AIzaSyA3TSL23CF_ymQ1qdDnEspt_frPRkb7xgA"
    
    let fetchWeatherData = FetchWeatherData()
    
    var sttViewModel = SpeechToTranslateViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        search_TextFiled.placeholder = " 지역(도시)를 검색해주세요"
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
                    
                    let camera = GMSCameraPosition(latitude: currentLat, longitude: currentLng, zoom: 17) //현재 위도, 경도로 카메라를 이동, 줌 레벨(확대되는 정도)는 17로 설정
                    gooogleMap = GMSMapView.map(withFrame: self.view.frame, camera: camera) // mapView 객체 생성
                    googleMap_view.addSubview(gooogleMap) // view에 mapView를 서브뷰로 추가
                    
                    let marker = GMSMarker() // 마커 객체 생성
                    marker.position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng) // 마커의 위치를 현재 위도, 경도로 설정
                    marker.title = "현재 위치" // 마커 터치하면 나오는 말풍선에 표시할 대제목
                    marker.snippet = "나" // 마커 터치하면 나오는 말풍선에 표시할 소제목
                    marker.map = gooogleMap // 마커를 표시할 맵
                }
        
        sttViewModelBind()
    }
    
    func fetchData(_ cityName: String) {
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
            self.iconImageView.kf.setImage(with: weather.weatherInfo[0].iconURL)
            self.cityNameLabel.text = weather.name
            self.mainDescriptionLabel.text = weather.weatherInfo[0].main
            self.subDescriptionLabel.text = weather.weatherInfo[0].desc
            self.temperatureLabel.text = "평균온도:  " + self.kelvinToCelsius(kValue: weather.tempInfo.temp) + "℃"
            self.feelsLikeLabel.text = "체감온도:  " + self.kelvinToCelsius(kValue: weather.tempInfo.feelsLike) + "℃"
            self.maxTemperatureLabel.text = "최고기온:  " + self.kelvinToCelsius(kValue: weather.tempInfo.tempMax) + "℃"
            self.minTemperatureLabel.text = "최저기온:  " + self.kelvinToCelsius(kValue: weather.tempInfo.tempMin) + "℃"
            


            let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(weather.coordInfo.lat), longitude: CLLocationDegrees(weather.coordInfo.lon))
            let newCamera = GMSCameraPosition.camera(withTarget: position,
                                                     zoom: self.gooogleMap.camera.zoom + 1)
            let update = GMSCameraUpdate.setCamera(newCamera)
            self.gooogleMap.moveCamera(update)
        }
    }
    
    func kelvinToCelsius(kValue: Float) -> String {
        let celsius = kValue - 273.15
        return String(format: "%.0f", celsius)
    }
    
    func alertError() {
        let alertController = UIAlertController(title: "Error", message: "City not found", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.sttViewModel.sttModel.isRecording.accept(false)
        })
        present(alertController, animated: true, completion: nil)
    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        fetchData(textField.text ?? "")
        print("텍스트필드 엔터 누를때",sttViewModel.sttModel.translatedText.value)
        fetchData(sttViewModel.sttModel.translatedText.value)
        textField.text = ""
        sttViewModel.sttModel.translatedText.accept("")
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
}
