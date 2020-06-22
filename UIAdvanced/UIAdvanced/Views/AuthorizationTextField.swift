//
//  AuthorizationTextField.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 08.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class AuthorizationTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 15, y: 0, width: bounds.width - 45, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 15, y: 0, width: bounds.width - 45, height: bounds.height)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 15, y: 0, width: bounds.width - 45, height: bounds.height)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: bounds.width - 30, y: bounds.height / 2 - 7.5, width: 15, height: 15)
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 45)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clearButtonMode = .whileEditing
        backgroundColor = .white
        
        font = UIFont.systemFont(ofSize: 14, weight: .regular)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
    
}
