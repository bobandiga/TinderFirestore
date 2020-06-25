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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print(uid)
        Firestore.firestore().collection("users").document(uid).getDocument { [weak self] (snapshot, error) in
            if let err = error {
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else { return }
            self?.user = User(dictionary)
            self?.fetchUserPhoto()
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    fileprivate func fetchUserPhoto() {
        guard let imageUrl = user?.imageNames.first, let url = URL(string: imageUrl) else { return }
        SDWebImageManager().loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
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
        headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        switch section {
        case 1:
            headerLabel.text = "Name"
        case 2:
            headerLabel.text = "Profession"
        case 3:
            headerLabel.text = "Age"
        case 4:
            headerLabel.text = "Bio"
        case 5:
            headerLabel.text = "Age range seek"
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
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let cell = RangeAgeCell(style: .default, reuseIdentifier: nil)
            cell.minAgeSlider.addTarget(self, action: #selector(minAgeChangeHandle(_:)), for: .valueChanged)
            cell.minAgeLabel.text = "Min \(user?.minSeekingAge ?? -1)"
            cell.maxAgeSlider.addTarget(self, action: #selector(maxAgeChangeHandle(_:)), for: .valueChanged)
            cell.maxAgeLabel.text = "Max \(user?.maxSeekingAge ?? -1)"
            return cell
        }
        
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(nameTFHandle(_:)), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(professionTFHandle(_:)), for: .editingChanged)
        case 3:
            cell.textField.placeholder = "Enter Age"
            cell.textField.text = String(user?.age ?? 0)
            cell.textField.addTarget(self, action: #selector(ageTFHandle(_:)), for: .editingChanged)
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let saveDict: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "image1Url": user?.imageNames.first ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? "",
            "minSeekingAge": user?.minSeekingAge ?? -1,
            "maxSeekingAge": user?.maxSeekingAge ?? -1,
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Save settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(saveDict) { (error) in
            hud.dismiss(animated: true)
            if let err = error {
                return
            }
            print("updated user info")
        }
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
    
    @objc
    func nameTFHandle(_ sender: UITextField) {
        print("Name: ", sender.text)
        user?.name = sender.text
    }
    
    @objc
    func professionTFHandle(_ sender: UITextField) {
        print("Profession: ", sender.text)
        user?.profession = sender.text
    }
    
    @objc
    func ageTFHandle(_ sender: UITextField) {
        print("Age: ", sender.text)
        user?.age = Int(sender.text ?? "")
    }
    
    @objc
    func minAgeChangeHandle(_ sender: UISlider) {
        let value = Int(sender.value)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? RangeAgeCell else { return }
        cell.minAgeLabel.text = "Min \(value)"
        self.user?.minSeekingAge = value
    }
    
    @objc
    func maxAgeChangeHandle(_ sender: UISlider) {
        let value = Int(sender.value)
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 5)) as? RangeAgeCell else { return }
        cell.maxAgeLabel.text = "Max \(value)"
        self.user?.maxSeekingAge = value
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
