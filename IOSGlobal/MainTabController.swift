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
                view.listTableView.reloadData()
            }
        }
}
