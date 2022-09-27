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

class WeatherOfCity: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeDiffer: UILabel!
    @IBOutlet weak var ampm: UILabel!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var temperature: UILabel! /// ℃ ° ℉
    
    static let identifier = "WeatherOfCity"
    
    let tap = UITapGestureRecognizer()
    var dBag = DisposeBag()
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 16))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dBag = DisposeBag()
    }
    
    func configData(_ data: Weather) {
        cityName.text = data.name//"레이캬비크"
        timeDiffer.text = "9시간 늦음"
        ampm.text = "오전"
        clock.text = "5:46"
//        weather.image = UIImage(systemName: "sun.min.fill")//UIImage(named: "")
        weather.kf.setImage(with: data.weatherInfo[0].iconURL)
        temperature.text = "\(String(format: "%.0f", data.tempInfo.temp - 273.15))℃"
        
        bind()
    }
    
    func bind() {
        self.addGestureRecognizer(tap)
        tap.rx.event
            .bind { [weak self] _ in
                guard let self = self else { return }
                print("\(self.cityName.text ?? "") 선택 ! ")
                // 지도 탭바에 데이터 전달
            }
            .disposed(by: dBag)
    }
}
