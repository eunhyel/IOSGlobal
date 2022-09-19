//
//  WeatherOfCity.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/19.
//

import UIKit

class WeatherOfCity: UITableViewCell {
    
    let identifier = "WeatherOfCity"
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var timeDiffer: UILabel!
    @IBOutlet weak var ampm: UILabel!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var weather: UIImageView!
    @IBOutlet weak var temperature: UILabel! /// ℃ ° ℉
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
