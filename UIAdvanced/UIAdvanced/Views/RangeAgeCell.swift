//
//  RangeAgeCell.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 25.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class RangeAgeCell: UITableViewCell {
    
    class CustomLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return CGSize(width: 88, height: 0)
        }
    }
    
    lazy var minAgeLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "Min -1"
        label.textAlignment = .center
        return label
    }()
    
    lazy var minAgeSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 18

        return slider
    }()
    
    lazy var maxAgeLabel: CustomLabel = {
        let label = CustomLabel()
        label.text = "Max -1"
        label.textAlignment = .center
        return label
    }()
    
    lazy var maxAgeSlider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 100
        slider.minimumValue = 18
        return slider
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minAgeLabel, minAgeSlider]),
            UIStackView(arrangedSubviews: [maxAgeLabel, maxAgeSlider])
        ])
        overallStackView.axis = .vertical
        overallStackView.alignment = .fill
        overallStackView.distribution = .fillEqually
        overallStackView.spacing = 8
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        addSubview(overallStackView)
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.fillToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
