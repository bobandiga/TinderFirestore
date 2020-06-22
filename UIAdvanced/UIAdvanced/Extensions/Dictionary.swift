//
//  Dictionary.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 12.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import Foundation

extension Dictionary {
    func getValues(index: Int) -> Value? {
        let element = enumerated().first { (element) -> Bool in
            return element.offset == index
        }
        return element?.element.value
    }
}
