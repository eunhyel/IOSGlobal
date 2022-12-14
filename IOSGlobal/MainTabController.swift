//
//  MainTabController.swift
//  IOSGlobal
//
//  Created by eunhye on 2022/09/28.
//

import Foundation
import UIKit

class MainTabCOntroller : UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
            self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

            if viewController is ViewController {
                print("First tab")
            }
            
            if let view = viewController as? WeatherListViewController {
                print("Second tab")
                view.listTableView.list.forEach { wcd in
                    FetchWeatherData().fetchData(cityName: wcd.name ?? "") { weather, error in
                        guard let weather = weather else { return }
                        CoreDataManager.shared.update(object: wcd, weather: weather)
                    }
                    
                }
                "날씨리스트".transText(nation: AppData.nationCode.rawValue, complete: { text in view.listTableView.header.title.text = text })
                view.listTableView.reloadData()
            }
        }
}
