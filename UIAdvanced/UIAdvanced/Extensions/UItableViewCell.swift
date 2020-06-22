//
//  UItableViewCell.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 12.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var cellId: String {
        return String(describing: self)
    }
}
