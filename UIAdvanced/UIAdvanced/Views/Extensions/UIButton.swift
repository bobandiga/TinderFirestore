//
//  UIButton.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 22.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

extension UIButton {
    static func createButton(size: CGSize, image: UIImage?) -> UIButton {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        button.layer.cornerRadius = size.width / 2
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(image, for: .normal)
        
        return button
    }

}


