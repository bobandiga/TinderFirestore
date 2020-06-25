//
//  ViewController.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 28.02.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit
import FirebaseFirestore
import JGProgressHUD

class HomeViewController: UIViewController {
    
    //MARK: - views
    fileprivate let topMenuView = TopNavigationStackView()
    fileprivate let cardDesckView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    fileprivate let bottomMenuView = HomeBottomControlsStackView()
    fileprivate lazy var overallStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [topMenuView, cardDesckView, bottomMenuView])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return stackView
    }()
    
    //MARK: - view model
    var cards = [CardViewModel]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout()
        
        fetchUsers()
    
        
    }
    
    
    //MARK: - fetch data
    fileprivate var lastFetchedUser: User?
    fileprivate func fetchUsers() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        
        query.getDocuments { (snapshot, error) in
            hud.dismiss(afterDelay: 1)
            if let error = error {
                print(error.localizedDescription)
            } else {
                snapshot?.documents.forEach({ [unowned self] (documentSnapshot) in
                    let userDictionary = documentSnapshot.data()
                    let user = User(userDictionary)
                    self.cards.append(CardViewModel(user: user))
                    self.lastFetchedUser = user
                    
                    let card = CardView()
                    card.cardViewModel = CardViewModel(user: user)
                    self.cardDesckView.addSubview(card)
                    self.cardDesckView.sendSubviewToBack(card)
                    card.fillToSuperview()
                })
            }
        }
    }
    
    //MARK: - Setup views
    fileprivate func setupViews() {
        view.backgroundColor = UIColor(white: 0.99, alpha: 1)
        view.addSubview(overallStackView)
        
        topMenuView.accountView.addTarget(self, action: #selector(accountHandle), for: .touchDown)
        bottomMenuView.reloadView.addTarget(self, action: #selector(refreshHandle), for: .touchDown)
    }
    
    //MARK: - actions
    @objc
    fileprivate func accountHandle() {
        
        let settingsController = SettingsViewController()
        let nav = UINavigationController(rootViewController: settingsController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
        
        return
        
        let vc = RegistrationViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    fileprivate func refreshHandle() {
        fetchUsers()
    }
    
    //MARK: - layout
    fileprivate func setupLayout() {
        
        overallStackView.constraintToSuperviewWith(l: 0, r: 0, t: nil, b: nil)
        overallStackView.constraintToSuperviewSafeAreaWith(l: nil, r: nil, t: 0, b: 0)
        
        topMenuView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        bottomMenuView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.bringSubviewToFront(cardDesckView)
        
    }
    
}

