//
//  SettingsTVDataSource.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 12.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject {
    var items: Dictionary<String, String> = [
        "Name": "Username",
        "Proffesion": "Gamer",
        "Age": "21",
        "Bio": "B.I.O",
    ]
}

extension TableViewDataSource: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = items.getValues(index: section) {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "A", for: indexPath)
        if let value = items.getValues(index: indexPath.section) {
            cell.textLabel?.text = value
        }
        return cell
        //return tableView.dequeuCell(UITableViewCell(), indexPath: indexPath)
    }
    
}
