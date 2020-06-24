//
//  SettingsCell.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 25.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    class SettingsTextField: UITextField {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 0, height: 44)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
    }
    
    lazy var textField: SettingsTextField = {
        let tf = SettingsTextField()
        tf.placeholder = "..."
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
