//
//  RegisterViewModel.swift
//  UIAdvanced
//
//  Created by Максим Шаптала on 09.04.2020.
//  Copyright © 2020 Максим Шаптала. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class RegisterViewModel {
    
    var isRegistering = Bindable<Bool>()
    var image = Bindable<UIImage>()
    var isFormValid = Bindable<Bool>()
    
    var fullName: String? {
        didSet{
            isFormValidCheck()
        }
    }
    
    var email: String? {
        didSet {
            isFormValidCheck()
        }
    }
    
    var pass: String? {
        didSet {
            isFormValidCheck()
        }
    }
    
    var confirmPass: String? {
        didSet {
            isFormValidCheck()
        }
    }
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = [
            "fullName": fullName ?? "",
            "uid": uid,
            "image1Url": imageURL,
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(data) { (error) in
            completion(error)
        }
        
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        guard let image = image.value else { return }
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        if let imageData = image.jpegData(compressionQuality: 0.5) {
            ref.putData(imageData, metadata: nil) { [unowned self] (data, error) in
                if let error = error {
                    completion(error)
                    return
                }
                ref.downloadURL { (url, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    self.saveInfoToFirestore(imageURL: url?.absoluteString ?? "", completion: completion)
                }
            }
            
        }
    }
    
    func preformRegistration(completion: @escaping (Error?) -> ()) {
        
        isRegistering.value = true
        
        guard let email = email, !email.isEmpty, let pass = pass, !pass.isEmpty, let confirmPass = confirmPass, !confirmPass.isEmpty, confirmPass == pass else {
            let error = NSError(domain: "", code: 500, userInfo: nil)
            isRegistering.value = false
            completion(error)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: confirmPass) { [unowned self] (result, error) in
            if let error = error {
                completion(error)
            } else {
                self.saveImageToFirebase(completion: completion)
            }
            
            self.isRegistering.value = false
        }
    }
    
    fileprivate func isFormValidCheck() {
        guard let fullName = fullName, fullName.isEmpty == false else {
            isFormValid.value = false
            return
        }
        
        guard let email = email, email.isEmpty == false else {
            isFormValid.value = false
            return
        }
        
        guard let pass = pass, pass.isEmpty == false else {
            isFormValid.value = false
            return
        }
        
        guard let confirmPass = confirmPass, confirmPass.isEmpty == false, confirmPass == pass else {
            isFormValid.value = false
            return
        }
        
        isFormValid.value = true
    }
}
