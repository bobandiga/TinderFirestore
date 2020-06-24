//
//  SettingsViewController.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 22.06.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import SDWebImage


class SettingsViewController: UITableViewController {
    
    fileprivate lazy var image1Button = createButton(selector: #selector(selectImage(_:)))
    fileprivate lazy var image2Button = createButton(selector: #selector(selectImage(_:)))
    fileprivate lazy var image3Button = createButton(selector: #selector(selectImage(_:)))
    
    fileprivate lazy var headerView: UIView = {
        let verticalStack = UIStackView(arrangedSubviews: [image2Button, image3Button])
        verticalStack.axis = .vertical
        verticalStack.distribution = .fillEqually
        verticalStack.spacing = 16
        verticalStack.alignment = .fill
        
        let horizontalStack = UIStackView(arrangedSubviews: [image1Button, verticalStack])
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .fillEqually
        horizontalStack.alignment = .fill
        horizontalStack.spacing = 16
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        
        let header = UIView()
        header.backgroundColor = .clear
        header.addSubview(horizontalStack)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.topAnchor.constraint(equalTo: header.topAnchor).isActive = true
        horizontalStack.leadingAnchor.constraint(equalTo: header.leadingAnchor).isActive = true
        horizontalStack.bottomAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        horizontalStack.trailingAnchor.constraint(equalTo: header.trailingAnchor).isActive = true
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentUser()
        setupNavigationItems()
        
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        
    }
    
    var user: User?
    fileprivate func fetchCurrentUser() {
        let uid = "zQ5WANIIAuQ7kwfOl6zfxttAWIU2"//Auth.auth().currentUser?.uid else { return }
        print(uid)
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] (snapshot, error) in
            if let err = error {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self?.user = User(dictionary)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 { return headerView }
        
        class HeaderLabel: UILabel {
            override func drawText(in rect: CGRect) {
                super.drawText(in: rect.insetBy(dx: 16, dy: 0))
            }
        }
        
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        default:
            break
        }
        
        return headerLabel
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 300 }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.text = String(user?.age ?? 0)
        case 4:
            cell.textField.placeholder = "Enter Bio"
            //cell.textField.text = user?.
        default:
            break
        }
        return cell
    }
}
//Setup Navigation
fileprivate extension SettingsViewController {
    func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(dismissHandle))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutHandle)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveHandle))
        ]
    }
}

//Actions
fileprivate extension SettingsViewController {
    @objc
    func dismissHandle() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveHandle() {
        
    }
    
    @objc
    func logoutHandle() {
        
    }

    
    @objc
    func selectImage(_ sender: UIButton) {
        let imagePicker = ButtonImagePickerController()
        imagePicker.senderButton = sender
        imagePicker.delegate = self
        navigationController?.present(imagePicker, animated: true, completion: nil)
    }
}

//UI
fileprivate extension SettingsViewController {
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Select Photo", for: .normal)
        button.addTarget(self, action: selector, for: .touchDown)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }
}

extension SettingsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage, let button = (picker as? ButtonImagePickerController)?.senderButton else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        let formattedImage = image.withRenderingMode(.alwaysOriginal)
        button.setImage(formattedImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
        
    }
}


class ButtonImagePickerController: UIImagePickerController {
    weak var senderButton: UIButton?
}
