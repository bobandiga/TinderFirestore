//
//  TopMenuView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 28.02.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

final class TopNavigationStackView: UIStackView{
    
    lazy var accountView: UIButton = {
        let image = UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.gray)
        return .createButton(size: CGSize(width: 45, height: 45), image: image)
    }()
    let hotView = UIView()
    lazy var chatView: UIButton = {
        let image = UIImage(systemName: "message.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.gray)
        return .createButton(size: CGSize(width: 45, height: 45), image: image)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        hotView.translatesAutoresizingMaskIntoConstraints = false
        hotView.widthAnchor.constraint(equalToConstant: 55).isActive = true
        hotView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        hotView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        hotView.layer.cornerRadius = 35/2
        
        addArrangedSubview(accountView)
        addArrangedSubview(hotView)
        addArrangedSubview(chatView)
    
        distribution = .equalCentering
        axis = .horizontal
        alignment = .center
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
