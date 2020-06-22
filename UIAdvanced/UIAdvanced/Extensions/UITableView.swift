//
//  UITableView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 12.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeuCell<T: UITableViewCell>(_ type: T, indexPath: IndexPath) -> T{
        let cell = dequeueReusableCell(withIdentifier: T.cellId, for: indexPath) as! T
        return cell
    }
}
