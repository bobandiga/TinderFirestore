//
//  CardView.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 28.02.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit
import SDWebImage

final class CardView: UIView{
    
    //MARK: - Subviews
    fileprivate let imageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "tempCard"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let barView = CardBarView()
    fileprivate let infoStack = CardInfoView()
    
    //MARK: - Configurations
    fileprivate let treshold: CGFloat = 80
    
    //MARK: - view model
    var cardViewModel: CardViewModel? {
        didSet{
            guard let viewModel = cardViewModel else { return }
            
            infoStack.title = viewModel.title
            infoStack.body = viewModel.body
            infoStack.subtitle = viewModel.subtitle
            infoStack.layoutType = viewModel.layoutType
            
            barView.setupLayout(with: viewModel.imageNames.count)
            if let imageUrl = URL(string: viewModel.imageNames[0]) {
                imageView.sd_setImage(with: imageUrl, completed: nil)
            }
            
            viewModel.selectedImageIndexObserver = { [weak self] (index, image) in
                self?.imageView.image = image
                self?.barView.updateLayout(selectedImageIndex: index)
            }
        
            setupLayout(layoutType: viewModel.layoutType)
        }
    }
    
    //MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(imageView)
        setupGradientLayer()
        addSubview(infoStack)
        addSubview(barView)
        
        setupGestures()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - LayoutSubviews
    override func layoutSubviews() {
        gradientLayer.frame = frame
    }
     
    //MARK: - setupLayout
    fileprivate func setupLayout(layoutType: ModelType) {
        barView.constraintToSuperviewWith(l: 10, r: -10, t: 10)
        barView.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
        imageView.fillToSuperview()
        switch layoutType {
        case .advertiser:
            infoStack.constraintToSuperviewWith(l: 20, r: -20, b: -20)
        case .user:
            infoStack.constraintToSuperviewWith(l: 20, b: -20)
            infoStack.trailingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        @unknown default:
            break
        }
    }
    
    //MARK: - setupGradientLayer
    fileprivate func setupGradientLayer(){
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.1]
        layer.addSublayer(gradientLayer)
    }

    //MARK: - Gesture
    fileprivate func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandle(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        addGestureRecognizer(tapGesture)
    }
    
    //
    @objc func tapHandle(_ sender: UITapGestureRecognizer) {
        let treshold = self.frame.width / 2
        let location = sender.location(in: nil).x
        
        if location > treshold {
            cardViewModel?.nextPhoto()
        }else{
            cardViewModel?.previousPhoto()
        }
    }
    
    //
    @objc func panHandle(_ sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            superview?.subviews.forEach({$0.layer.removeAllAnimations()})
        case .ended:
            handleEnded(sender)
        case .changed:
            handleChanged(sender)
        default:
            break
        }
    }
    
    //
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let translationDirection: CGFloat = translation.x > 0 ? 1 : -1
        let shouldDismissCard = abs(translation.x) > treshold
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseOut],
                       animations: {
                        
                        if shouldDismissCard {
                            self.transform = CGAffineTransform(translationX: 600 * translationDirection, y: 0)
                        } else {
                            self.transform = .identity
                        }
        },
                       completion: { (_) in
                        self.transform = .identity
                        if shouldDismissCard {
                            self.removeFromSuperview()
                        }
        })
    }
    
    //
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees = translation.x / 20 * .pi / 180
        let rotationTransform = CGAffineTransform(rotationAngle: degrees)
        let translateTransform = rotationTransform.translatedBy(x: translation.x, y: translation.y)
        transform = translateTransform
    }
    
}
