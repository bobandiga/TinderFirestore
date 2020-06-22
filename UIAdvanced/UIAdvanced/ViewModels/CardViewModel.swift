//
//  CardViewModel.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 06.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit

enum ModelType {
    case user
    case advertiser
}

class CardViewModel {
    let imageNames: [String]
    let title: String
    let subtitle: String
    let body: String
    let layoutType: ModelType
    
    fileprivate var selectedImageIndex : Int {
        didSet {
            let image = UIImage(named: imageNames[selectedImageIndex])
            selectedImageIndexObserver?(selectedImageIndex, image)
        }
    }
    
    var selectedImageIndexObserver : ((Int, UIImage?) -> ())?
    
    func nextPhoto() {
        selectedImageIndex = min(imageNames.count - 1, selectedImageIndex + 1)
    }
    
    func previousPhoto() {
        selectedImageIndex = max(0, selectedImageIndex - 1)
    }
    
    init(user: User) {
        imageNames = user.imageNames
        title = user.name ?? ""
        subtitle = String(user.age ?? 0)
        body = user.profession ?? ""
        layoutType = .user
        
        selectedImageIndex = 0
    }
    
    init(advertiser: Advertiser) {
        imageNames = [advertiser.imageName]
        title = advertiser.title
        body = advertiser.brandName
        subtitle = ""
        layoutType = .advertiser
        
        selectedImageIndex = 0
    }
}
