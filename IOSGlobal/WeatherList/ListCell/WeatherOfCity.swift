//
//  WeatherOfCity.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/19.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import CoreLocation
import TimeZoneLocate

class WeatherOfCity: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var ampm: UILabel!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var temperature: UILabel! /// ℃ ° ℉
    
    static let identifier = "WeatherOfCity"
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    var liveTimer: Timer? = nil
    
    let tap = UITapGestureRecognizer()
    var dBag = DisposeBag()
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        liveTimer?.invalidate()
        dBag = DisposeBag()
    }
    
    func configData(_ data: WeatherCd) {
//        getTime(cData: data)
        let data = getWeather(cData: data)
        
        data.name.transText(nation: AppData.nationCode.rawValue, complete: { text in
            self.cityName.text = text
        })//"레이캬비크"
        weather.kf.setImage(with: data.weatherInfo[0].iconURL)
        temperature.text = "\(String(format: "%.0f", data.tempInfo.temp - 273.15))℃"
        
        bind(core: data)
        
    }
    
    func bind(core: Weather) {
        self.addGestureRecognizer(tap)
        tap.rx.event
            .bind { [weak self] _ in
                guard let self = self else { return }
                print("\(core.coordInfo.lat) | \(core.coordInfo.lon)")
                self.goToCity(info: core)
                // 지도 탭바에 데이터 전달
            }
            .disposed(by: dBag)
    }
    
    func getWeather(cData: WeatherCd) -> Weather {
//            return data.map { fetchs in
            let fetchs = cData
            var weatherInfoArr: [WeatherInfo] = []
            let fetchs_set = fetchs.weatherInfo!
            // let fetchs_arr = Array(fetchs_set)
            let fetchs_arr = NSMutableArray(array: fetchs_set.array) as! [WeatherInfoCd]
            fetchs_arr.forEach { fetInfo in // WeatherInfoCd
                let winfo = WeatherInfo(id: Int(fetInfo.id),
                                        main: String(fetInfo.main ?? ""),
                                        desc: String(fetInfo.desc ?? ""),
                                        icon: fetInfo.icon)
                weatherInfoArr.append(winfo)
            }
            
            let _tempInfo = TempInfo(temp: fetchs.tempInfo!.temp,
                                     feelsLike: fetchs.tempInfo!.feelsLike,
                                     tempMin: fetchs.tempInfo!.tempMin,
                                     tempMax: fetchs.tempInfo!.tempMax)
            let _coordInfo = CoordInfo(lon: fetchs.coordInfo?.lon ?? 0.0, lat: fetchs.coordInfo?.lat ?? 0.0)
            
            return Weather(weatherInfo: weatherInfoArr,
                           tempInfo: _tempInfo,
                           coordInfo: _coordInfo,
                           name: fetchs.name ?? "")
//        }
    }
    
    func getTime(cData: WeatherCd) {
        guard let coordInfo = cData.coordInfo else {
            return
        }
        
        formatter.timeZone = TimeZoneLocate.timeZoneWithLocation(CLLocation(latitude: CLLocationDegrees(coordInfo.lat), longitude: CLLocationDegrees(coordInfo.lon)))
        liveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateClockLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(liveTimer!, forMode: .common)
        
        ampm.text = ""//formatter.string(from: Date())
        clock.text = formatter.string(from: Date())
        
        
    }
    
    @objc func updateClockLabel() {
        ampm.text = ""//formatter.string(from: Date()).components(separatedBy: " ")[0].lowercased()
        clock.text = formatter.string(from: Date())
    }
    
    func goToCity(info: Weather) {
        let view = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController as? UITabBarController
        view?.selectedIndex = 0
        (view?.selectedViewController as? ViewController)?.fetchData(info.name)
    }
}
