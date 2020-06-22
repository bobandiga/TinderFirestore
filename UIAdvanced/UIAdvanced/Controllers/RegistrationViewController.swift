//
//  AuthorizationViewController.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 08.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD
import FirebaseAuth
import FirebaseStorage

class RegistrationViewController: UIViewController {
    
    //MARK: - view model
    var registerViewModel: RegisterViewModel? {
        didSet {
            guard let viewModel = registerViewModel else { return }
            viewModel.image.bind { [unowned self] (image) in
                self.photo.setImage(image, for: .normal)
            }
            viewModel.isFormValid.bind { [unowned self] (isSuccess) in
                guard let isSuccess = isSuccess else { return }
                self.registerBtn.isEnabled = isSuccess
            }
            viewModel.isRegistering.bind { [unowned self] (isRegistering) in
                guard let isRegistering = isRegistering else { return }
                if isRegistering == true {
                    self.hudView.textLabel.text = "Registering"
                    self.hudView.show(in: self.view)
                } else {
                    self.hudView.dismiss(afterDelay: 2)
                    self.hudView.textLabel.text = ""
                    self.hudView.detailTextLabel.text = ""
                }
            }
        }
    }
    
    //MARK: - views
    fileprivate let hudView = JGProgressHUD(style: .dark)
    fileprivate let gradientLayer = CAGradientLayer()
    
    fileprivate let photo: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .white
        button.setTitle("Select photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        button.addTarget(nil, action: #selector(openImagePickerCpntroller(_:)), for: .touchDown)
        return button
    }()
    
    fileprivate let nameTF: AuthorizationTextField = {
        let textField = AuthorizationTextField()
        textField.placeholder = "User name"
        textField.addTarget(nil, action: #selector(textDidChangeAction(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let emailTF: AuthorizationTextField = {
        let textField = AuthorizationTextField()
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email adress"
        textField.addTarget(nil, action: #selector(textDidChangeAction(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let passTF: AuthorizationTextField = {
        let textField = AuthorizationTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.addTarget(nil, action: #selector(textDidChangeAction(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let confirmPassTF: AuthorizationTextField = {
        let textField = AuthorizationTextField()
        textField.isSecureTextEntry = true
        textField.placeholder = "Confirm password"
        textField.addTarget(nil, action: #selector(textDidChangeAction(_:)), for: .editingChanged)
        return textField
    }()
    
    fileprivate let registerBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), for: .disabled)
        button.isEnabled = false
        button.layer.cornerRadius = 10
        button.addTarget(nil, action: #selector(registerBtnHandle(_:)), for: .touchDown)
        return button
    }()
    
    fileprivate lazy var overallStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameTF, emailTF, passTF,confirmPassTF, registerBtn])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        sv.setCustomSpacing(24, after: confirmPassTF)
        sv.alignment = .fill
        
        let stackView = UIStackView(arrangedSubviews: [photo, sv])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    fileprivate let logintBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Go to login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    
    //MARK: - Actions
    @objc fileprivate func textDidChangeAction(_ sender: UITextField) {
        let text = sender.text
        switch sender {
        case nameTF:
            registerViewModel?.fullName = text
            break
        case emailTF:
            registerViewModel?.email = text
            break
        case passTF:
            registerViewModel?.pass = text
            break
        case confirmPassTF:
            registerViewModel?.confirmPass = text
            break
        default:
            break
        }
    }
    
    @objc fileprivate func openImagePickerCpntroller(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        if let value = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
            let keyboardFrame = value.cgRectValue
            let bottomSpace = view.frame.height - overallStackView.frame.origin.y - overallStackView.frame.height
            print(bottomSpace)
            let difference = -(keyboardFrame.height - bottomSpace + 8)
            view.transform = CGAffineTransform.init(translationX: 0, y: difference)
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        if let value = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? NSValue {
            UIView.animate(withDuration: (value as! Double),
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [unowned self] in
                            self.view.transform = .identity
            },
                           completion: nil)
        }
    }
    
    @objc fileprivate func tapGestureHandle(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc fileprivate func registerBtnHandle(_ sender: UIButton) {
        view.endEditing(true)
        
        registerViewModel?.preformRegistration(completion: { [weak self] (error) in
            if let error = error {
                self?.hudView.detailTextLabel.text = error.localizedDescription
            }
        })
    }
    
    //MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupLayout(for: traitCollection)
        setupGradientLayer()
        setupGestures()
        setupNotificationCenter()
        
        registerViewModel = RegisterViewModel()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    //MARK: - setup gestures
    fileprivate func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.addTarget(self, action: #selector(tapGestureHandle(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK; - setup notification center
    fileprivate func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - setup views
    fileprivate func setupViews() {
        view.layer.addSublayer(gradientLayer)
        view.addSubview(overallStackView)
        view.addSubview(logintBtn)
        
    }
    
    //MARK: - setup layout
    fileprivate func setupLayout(for traitCollection: UITraitCollection) {
        
        logintBtn.constraintToSuperviewSafeAreaWith(l: nil, r: nil, t: nil, b: 0)
        logintBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logintBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        overallStackView.constraintToSuperviewWith(l: 40, r: -40, t: nil, b: nil)
        overallStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        //overallStackView.bottomAnchor.constraint(greaterThanOrEqualTo: logintBtn.topAnchor, constant: -10).isActive = true
        
        switch traitCollection.verticalSizeClass {
        case .compact:
            overallStackView.axis = .horizontal
            photo.widthAnchor.constraint(equalToConstant: 275).isActive = true
            break
        case .regular:
            fallthrough
        default:
            overallStackView.axis = .vertical
            photo.heightAnchor.constraint(equalToConstant: 275).isActive = true
            break
        }
    }
    
    
    //MARK: - gradient layer
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).cgColor,#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).cgColor]
        gradientLayer.locations = [0,1]
    }
    
    //MARK: - traitCollectionDidChange
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupLayout(for: traitCollection)
    }
    
}

//MARK: - RegistrationViewController: UINavigationControllerDelegate
extension RegistrationViewController: UINavigationControllerDelegate { }

//MARK: - RegistrationViewController: UIImagePickerControllerDelegate
extension RegistrationViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            registerViewModel?.image.value = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
