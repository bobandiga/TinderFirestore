//
//  UIView+AutoLayout.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 07.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

extension UIView{
    func fillToSuperview(){
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
        ])
    }
    
    func fillToSuperviewSafeArea(){
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func constraintToSuperviewWith(l: CGFloat? = nil, r: CGFloat? = nil, t: CGFloat? = nil, b: CGFloat? = nil) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        if let leading = l {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = r {
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
        }
        if let bottom = b {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        }
        if let top = t {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
    }
    
    func constraintToSuperviewSafeAreaWith(l: CGFloat? = nil, r: CGFloat? = nil, t: CGFloat? = nil, b: CGFloat? = nil) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        if let leading = l {
            self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing = r {
            self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: trailing).isActive = true
        }
        if let bottom = b {
            self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: bottom).isActive = true
        }
        if let top = t {
            self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: top).isActive = true
        }
    }

}
