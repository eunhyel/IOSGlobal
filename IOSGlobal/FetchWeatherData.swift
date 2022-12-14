//
//  FetchWeatherData.swift
//  WeatherApp
//
//  Created by yc on 2022/02/18.
//

import UIKit
import Alamofire
import Kingfisher
import CoreLocation

struct FetchWeatherData {
    private let APIKEY = "544c62d89118e488cbd1925dbdf900df"
    func fetchData(cityName: String, completionHandler: @escaping (Weather?, AFError?) -> Void) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(APIKEY)"
        DispatchQueue.global().async {
            AF.request(url)
                .responseDecodable(of: Weather.self) { response in
                    switch response.result {
                    case .success(let data):
                        DispatchQueue.main.async {
                            completionHandler(data, nil)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completionHandler(nil, error)
                        }
                        print(error.localizedDescription, "000")
                    }
                }
        }
    }
    
    func getTimeZoneFromCoord(coord: CoordInfo, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let location = CLLocation(latitude: CLLocationDegrees(coord.lat), longitude: CLLocationDegrees(coord.lon))
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                completionHandler(placemark)
            } else if error != nil {
                completionHandler(nil)
            }
        }
    }
}
