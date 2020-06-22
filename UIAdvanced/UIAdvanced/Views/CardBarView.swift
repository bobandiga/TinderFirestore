//
//  BarView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 07.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class CardBarView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        spacing = 5
        alignment = .fill
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(with viewCount: Int) {
        if viewCount < 2 { return }
        for _ in 0..<viewCount {
            let view = UIView()
            view.backgroundColor = UIColor(white: 1, alpha: 0.4)
            addArrangedSubview(view)
        }
        updateLayout(selectedImageIndex: 0)
    }
    
    func updateLayout(selectedImageIndex: Int) {
        if arrangedSubviews.count > 1 {
            arrangedSubviews.forEach({$0.backgroundColor = UIColor(white: 1, alpha: 0.4)})
            arrangedSubviews[selectedImageIndex].backgroundColor = UIColor(white: 1, alpha: 1)
        }
    }
    
}
