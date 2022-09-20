//
//  WeatherListTableView.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/19.
//

import UIKit

class WeatherListTableView: UITableView {
    
    var listOfCityCollection = [String]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        initTableView()
    }
    
    func initTableView() {
        backgroundColor = .systemBackground
        register(UINib(nibName: "WeatherOfCity", bundle: nil), forCellReuseIdentifier: WeatherOfCity.identifier)
        listOfCityCollection = ["일", "이", "삼", "사", "오", "일", "이", "삼", "사", "오"]
        let header = WeatherOfCityHeader(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 100))
        header.title.text = "컬렉션 내"
        self.tableHeaderView = header
    }
    
}

extension WeatherListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCityCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCityCell = tableView.dequeueReusableCell(withIdentifier: WeatherOfCity.identifier, for: indexPath) as? WeatherOfCity {
            myCityCell.configData()
            return myCityCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) { // 편집
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            self.listOfCityCollection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash.circle.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    
}
