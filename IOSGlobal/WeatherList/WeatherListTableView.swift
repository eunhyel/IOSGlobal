//
//  WeatherListTableView.swift
//  IOSGlobal
//
//  Created by root0 on 2022/09/19.
//

import UIKit
import CoreData

class WeatherListTableView: UITableView {
    
    var list: [WeatherCd] = {
        return CoreDataManager.shared.fetch(request: WeatherCd.fetchRequest()) as! [WeatherCd]
    }()
//    var listDataSource: [Weather] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
        self.dataSource = self
        initTableView()
    }
    
    override func reloadData() {
        list = CoreDataManager.shared.fetch(request: WeatherCd.fetchRequest())
        super.reloadData()
    }
    func initTableView() {
        backgroundColor = .systemBackground
        register(UINib(nibName: "WeatherOfCity", bundle: nil), forCellReuseIdentifier: WeatherOfCity.identifier)
        
        let header = WeatherOfCityHeader(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 100))
        header.title.text = "컬렉션 내"
        self.tableHeaderView = header
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    
    @objc func refresh() {
        reloadData()
        refreshControl?.endRefreshing()
    }
}

extension WeatherListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
//        return listDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCityCell = tableView.dequeueReusableCell(withIdentifier: WeatherOfCity.identifier, for: indexPath) as? WeatherOfCity {
            myCityCell.getTime(cData: list[indexPath.row])
            myCityCell.configData(list[indexPath.row])
            return myCityCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
//            (self.list as! [WeatherCd])
            CoreDataManager.shared.delete(object: self.list[indexPath.row])
            tableView.reloadData()
            
            completionHandler(true)
        }
        delete.image = UIImage(systemName: "trash.circle.fill")
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])
        return configuration
    }
    
    
}
