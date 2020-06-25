//
//  User.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 06.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var age: Int?
    var profession: String?
    let imageNames: [String]
    var uid: String?
    
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    init(_ dictionary: [String: Any]) {
        name = dictionary["fullName"] as? String
        age = dictionary["age"] as? Int
        profession = dictionary["profession"] as? String
        imageNames = [dictionary["image1Url"] as? String ?? ""]
        uid = dictionary["uid"] as? String
        minSeekingAge = dictionary["minSeekingAge"] as? Int
        maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
}


