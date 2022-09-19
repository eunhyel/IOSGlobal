//
//  WeatherListViewController.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/19.
//

import UIKit

class WeatherListViewController: UIViewController {
    
    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var listTableView: WeatherListTableView!
    var weatherList = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
