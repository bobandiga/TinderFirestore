//
//  SettingsViewController.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 22.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
    }
    
    
    
}
//Setup Navigation
fileprivate extension SettingsViewController {
    func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissHandle))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveHandle)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandle))
        ]
    }
    
    @objc
    func dismissHandle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveHandle() {
        
    }
    
    @objc
    func logoutHandle() {
        
    }
}
