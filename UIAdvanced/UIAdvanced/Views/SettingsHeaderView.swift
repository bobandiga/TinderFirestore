//
//  SettingsHeaderView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 13.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {
    
    fileprivate func generatePhotoButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.backgroundColor = .white
        return button
    }
    
    lazy var button1 : UIButton = {
        return generatePhotoButton()
    }()
    
    lazy var button2 : UIButton = {
        return generatePhotoButton()
    }()
    
    lazy var button3 : UIButton = {
        return generatePhotoButton()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView(arrangedSubviews: [button2, button3])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        
        let overallStackView = UIStackView(arrangedSubviews: [button1, stackView])
        overallStackView.translatesAutoresizingMaskIntoConstraints = false
        overallStackView.distribution = .fillEqually
        overallStackView.axis = .horizontal
        overallStackView.alignment = .fill
        overallStackView.spacing = 8
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        
        addSubview(overallStackView)
        overallStackView.fillToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
