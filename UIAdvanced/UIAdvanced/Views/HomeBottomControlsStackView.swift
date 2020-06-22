//
//  BottomMenuView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 28.02.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

final class HomeBottomControlsStackView: UIStackView{
    lazy var reloadView: UIButton = {
        let image = UIImage(systemName: "arrow.uturn.left.circle.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.yellow)
        return .createButton(size: CGSize(width: 45, height: 45), image: image)
    }()
    
    lazy var nopeView: UIButton = {
        let image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.red)
        return .createButton(size: CGSize(width: 55, height: 55), image: image)
    }()
    
    lazy var superlikeView: UIButton = {
        let image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.blue)
        return .createButton(size: CGSize(width: 45, height: 45), image: image)
    }()
    
    lazy var likeView: UIButton = {
        let image = UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(.green)
        return .createButton(size: CGSize(width: 55, height: 55), image: image)
    }()
    
    lazy var powerView: UIButton = {
        let image = UIImage(systemName: "bolt.fill")?.withRenderingMode(.alwaysTemplate)
        image?.withTintColor(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
        return .createButton(size: CGSize(width: 45, height: 45), image: image)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = true
         
        addArrangedSubview(reloadView)
        addArrangedSubview(nopeView)
        addArrangedSubview(superlikeView)
        addArrangedSubview(likeView)
        addArrangedSubview(powerView)
        
        distribution = .equalCentering
        axis = .horizontal
        alignment = .center
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
