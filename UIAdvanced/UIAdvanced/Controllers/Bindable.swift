//
//  Bindable.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 09.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import Foundation

class Bindable<T> {
    
    var value: T?{
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
