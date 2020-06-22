//
//  InfoView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 07.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

class CardInfoView: UIStackView {
 
    var title: String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    var body: String?{
        didSet{
            bodyLabel.text = body
        }
    }
    
    var subtitle: String?{
        didSet{
            subtitleLabel.text = subtitle
        }
    }
    
    var layoutType: ModelType! {
        didSet{
            updateLayout(layoutType: layoutType)
        }
    }
    
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 2), for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 24, weight: .black)
        return label
    }()
    
    fileprivate let subtitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return label
    }()
    
    fileprivate let bodyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
      
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.spacing = 5
        stack.alignment = .fill
        stack.axis = .horizontal
        stack.distribution = .fill
        
        addArrangedSubview(stack)
        addArrangedSubview(bodyLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 5
        alignment = .fill
        axis = .vertical
        distribution = .fill
        
        layoutType = .user
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    fileprivate func updateLayout(layoutType: ModelType){
        switch layoutType {
        case .advertiser:
            titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
            subtitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 2), for: .horizontal)
            bodyLabel.textAlignment = .center
            bodyLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
            titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .black)
        case .user:
            break
        @unknown default:
            break
        }
    }
    
}
